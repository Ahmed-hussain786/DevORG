public with sharing class AccountController {
    public static List<Account> getAllActiveAccounts() {
        return [SELECT Id,Name,AccountNumber FROM Account WHERE Active__c = 'Yes'];

    }
}