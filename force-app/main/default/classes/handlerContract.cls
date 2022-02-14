public class handlerContract {
    
    public static void createOpportunities(List<Opportunity> newOpportunities,List<Opportunity> oldOpportunities,Map<Id,Opportunity> mapNewOpportunities,Map<Id,Opportunity> mapOldOpportunities,Boolean isInsert)
    {
        System.debug('@@@New Opp' + newOpportunities);
        System.debug('@@@old Opp' + oldOpportunities);
        System.debug('@@@New Opp map' + mapNewOpportunities);
        System.debug('@@@old Opp map' + mapOldOpportunities);
        List<Contract__c> lstContracts=new List<Contract__c>();
        Map<Id,Account> mapAllAccounts = new Map<Id,Account>();
        
        for(Account a : [Select id,name,ContractTermInMonths__c from account])
        {
            mapAllAccounts.put(a.id,a);
        }
        for(Opportunity opp:newOpportunities){
            if(!isInsert){
                if(mapOldOpportunities.get(opp.id).StageName <> 'Closed Won'){
                    
                    
                    //  if(opp.StageName=='Closed Won' && mapOldOpportunities.get(opp.id).StageName <> 'Closed Won'){
                    
                    Contract__c con = new Contract__c();
                    con.ContractName__c=opp.account + '-'+ opp.Name + '-'+ 'Contract';
                    con.AccountID__c=opp.AccountId;
                    con.Status__c='Accepted';
                    con.StartDate__C=Date.today();
                    con.ContractStartDate__c=Date.today();
                    con.ContractEndDate__c = getContractEndDate(Date.today(),mapAllAccounts.get(con.AccountID__c).ContractTermInMonths__c);
                    con.ContractTerm__c= mapAllAccounts.get(con.AccountID__c).ContractTermInMonths__c;
                    con.CustomerSignedby__c=opp.BillingEmployee__c;
                    lstContracts.add(con);
                    //  }
                }
            }
            else{
                if(opp.StageName=='Closed Won'){
                    Contract__c con = new Contract__c();
                    con.ContractName__c=opp.account + '-'+ opp.Name + '-'+ 'Contract';
                    con.AccountID__c=opp.AccountId;
                    con.Status__c='Accepted';
                    con.StartDate__C=Date.today();
                    con.ContractStartDate__c=Date.today();
                    con.ContractEndDate__c = getContractEndDate(Date.today(),mapAllAccounts.get(con.AccountID__c).ContractTermInMonths__c);
                    con.ContractTerm__c= mapAllAccounts.get(con.AccountID__c).ContractTermInMonths__c;
                    con.CustomerSignedby__c=opp.BillingEmployee__c;
                    lstContracts.add(con);
                }
            }
        }
        if(lstContracts.size()>0)
            insert lstContracts;
    }
    
    static date getContractEndDate(date startdate, decimal contractterm)
    {
        return startdate.addDays((integer)contractTerm*30);
    }
    
}