/**
 * Created by dtoczko on 06.07.2022.
 */

public with sharing class WebinarTriggerHandler {

    public static void handleBeforeInsert(List<Webinar__c> webinars) {
        approveBelow100(webinars);
        cancelRejected(webinars);
        disallowMoreParticipantsThanSeats(webinars);
        calculatePricePerParticipant(webinars);
    }

    public static void handleAfterInsert(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            WebinarEvent__e webinarEvent = new WebinarEvent__e(salesforce_id__c = webinar.Id);
            EventBus.publish(webinarEvent);
        }
    }

    public static void handleBeforeUpdate(List<Webinar__c> webinars) {
        cancelRejected(webinars);
        disallowMoreParticipantsThanSeats(webinars);
        calculatePricePerParticipant(webinars);
        statusChanged(webinars);
    }

    private static void approveBelow100(List<Webinar__c> webinars) {
        for (Webinar__c web : webinars) {
            if (web.Cost__c < 100) {
                web.Approval_Status__c = 'Approved';
            }
        }
    }

    private static void cancelRejected(List<Webinar__c> webinars) {
        for (Webinar__c web : webinars) {
            if (web.Approval_Status__c == 'Rejected') {
                web.Status__c = 'Canceled';
            }
        }
    }

    private static void disallowMoreParticipantsThanSeats(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.Total_Number_of_Seats__c < webinar.Number_of_Participants__c) {
                webinar.addError('Too many participants! Increase number of seats.');
            }
        }
    }

    private static void calculatePricePerParticipant(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.Cost__c == null) {
                webinar.addError('Webinar cost cannot be empty');
            }
            if (webinar.Number_of_Participants__c == null) {
                webinar.addError('Number of participants cannot be empty');
            }

            webinar.Price_per_participant__c = (webinar.Cost__c / webinar.Number_of_Participants__c);
        }
    }

    private static void statusChanged(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.Status__c != 'New' || webinar.Status__c != 'Canceled') {
                if (webinar.Approval_Status__c == 'Pending') {
                    webinar.addError('Approval status cannot be Pending if Status is -> New');
                }
            }
        }
    }


}