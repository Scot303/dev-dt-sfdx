/**
 * Created by dtoczko on 07.07.2022.
 */

@IsTest
public with sharing class TEST_DataFactory {
    public static Account createTestAccount(Boolean withAddress) {
        return createTestAccount(withAddress, true);
    }

    public static Account createTestAccount(Boolean withAddress, Boolean doInsert) {
        Account acc = new Account(Name = 'TestAccount');
        if (withAddress) {
            acc.ShippingCity = 'TestCity';
            acc.ShippingCountry = 'Poland';
            acc.ShippingPostalCode = 'TPC';
            acc.ShippingStreet = 'TestStreet';
        }

        if (doInsert) {
            insert acc;
        }

        return acc;
    }

    public static Opportunity createTestOpportunity(Account account) {
        return createTestOpportunity(account, true);
    }

    public static Opportunity createTestOpportunity(Account account, Boolean doInsert) {
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Name = 'testName';
        opportunity.StageName = 'New';
        opportunity.CloseDate = date.parse('05/11/2012');
        if (doInsert) {
            insert opportunity;
        }

        return opportunity;
    }

    public static Contact createTestContact(String name) {
        return createTestContact(name, true);
    }
    public static Contact createTestContact(String name, Boolean doInsert) {
        Contact contact = new Contact();
        contact.LastName = name;
        contact.MailingCity = 'TestCity';
        contact.MailingCountry = 'Poland';
        contact.MailingPostalCode = 'TPC';
        contact.MailingStreet = 'TestStreet';
        contact.Phone = '63636363636';
        contact.Email = 'del@del.com';
        if (doInsert) {
            insert contact;
        }
        return contact;
    }

    public static Webinar__c createTestWebinar(Double cost, Integer numOfSeats, Integer numOfParticipants, String approvalStatus, String status) {
        return createTestWebinar(cost, numOfSeats, numOfParticipants, approvalStatus, status, true);
    }

    public static Webinar__c createTestWebinar(Double cost, Integer numOfSeats, Integer numOfParticipants, String approvalStatus, String status, Boolean doInsert) {
        Webinar__c webinar = new Webinar__c();
        webinar.Cost__c = cost;
        webinar.Number_of_Participants__c = numOfParticipants;
        webinar.Total_Number_of_Seats__c = numOfSeats;
        webinar.Approval_Status__c = approvalStatus;
        webinar.Status__c = status;

        if (doInsert) {
            insert webinar;
        }

        return webinar;
    }

    public static Webinar_Member__c createTestWebinarMember(String status, String comment, Contact contact, User user) {
        return createTestWebinarMember(status, comment, contact, user, true);
    }

    public static Webinar_Member__c createTestWebinarMember(String status, String comment, Contact contact, User user, Boolean doInsert) {
        Webinar_Member__c webinarMember = new Webinar_Member__c();
        webinarMember.Status__c = status;
        webinarMember.Comments__c = comment;
        webinarMember.Related_Contact__c = contact.Id;
        webinarMember.Related_User__c = user.Id;

        if (doInsert) {
            insert webinarMember;
        }

        return webinarMember;
    }
}