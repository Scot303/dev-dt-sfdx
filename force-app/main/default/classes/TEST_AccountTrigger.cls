/**
 * Created by dtoczko on 07.07.2022.
 */

@IsTest
public with sharing class TEST_AccountTrigger {

    @IsTest
    private static void preventAccountDeletionIfHasRelatedOpportunitiesTest() {
        Account account = TEST_DataFactory.createTestAccount(true);
        TEST_DataFactory.createTestOpportunity(account);
        Test.startTest();
        Database.DeleteResult result = Database.delete(account, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related opportunities.', result.getErrors()[0].getMessage());
    }
}