public class TransactionBusinessLogic {
    
    public static void isDeleteLogic(List<Transaction__c> oldRecords){
        
        set<id> Ids = new set<id>();
        
        //This list will keep the final version of expense records that need to modify
        List<expense__c> updateExpense = new List<expense__c>();
        
        //This list will keep the final version of revenue records that need to modify
        List<revenue__c> updateRevenue = new List<revenue__c>();
        
        //This map will contain the Unique ID either revenue or expense against the amount.
        Map<Id,decimal> mapRevenueExpenseIDToTotalAmount = new Map<Id,Decimal>();
        
        
        String Key = '';
        for(Transaction__c oldT : oldRecords){
            if(oldT.expense__c==null && oldT.revenue__C!=null){
                key=oldT.revenue__c;
                Ids.add(key);
            }
            else if(oldT.revenue__c==null && oldT.expense__c!=null){
                key=oldT.expense__C;
                Ids.add(key);
            }
            else if(oldT.expense__c==null && oldT.revenue__c==null){
                oldT.addError('for this operation it should be expense or revenue');
            }
            else
                oldT.addError('both operations cant do at same time');
            
            
            mapRevenueExpenseIDToTotalAmount.put(Key, oldT.Amount__c);
            
        }
        System.debug('@@@ IDs' +Ids);
        System.debug('@@@ size' +Ids.size());
        List<expense__c> lstExpense = [select id, Total_Transactions__c,Total_Amount_Of_Expanse__c from expense__C where id in :Ids];
        System.debug('@@@ expense size' +lstExpense.size());
        
        for(expense__c e :lstExpense)
        {
            if(e.Total_Transactions__c==null)
            {
                e.Total_Transactions__c =0;
            }
            
            e.Total_Transactions__c = e.Total_Transactions__c - 1;
            
            IF( e.Total_Amount_Of_Expanse__c==NULL){
                e.Total_Amount_Of_Expanse__c=0;
            }
            e.Total_Amount_Of_Expanse__c = e.Total_Amount_Of_Expanse__c - mapRevenueExpenseIDToTotalAmount.get(e.id);
            updateExpense.add(e);
        }
        List<revenue__c> lstRevenue = [select id, Total_Transactions__c,Total_Amount_Of_Revenue__c from revenue__C where id in :Ids];
        System.debug('@@@ revenue size' +lstRevenue.size());
        
        for(revenue__c r :lstRevenue){
            
            if(r.Total_Transactions__c==null)
            {
                r.Total_Transactions__c =0;
            }
            
            r.Total_Transactions__c = r.Total_Transactions__c - 1;
            
            IF( r.Total_Amount_Of_Revenue__c==NULL){
                r.Total_Amount_Of_Revenue__c=0;
            }
            r.Total_Amount_Of_Revenue__c = r.Total_Amount_Of_Revenue__c - mapRevenueExpenseIDToTotalAmount.get(r.id);
            updateRevenue.add(r);
        }
        If(updateRevenue.size() > 0)
        {
            update updateRevenue;
        }
        If(updateExpense.size() > 0)
        {
            update updateExpense;
        } 
        
    }
    public Static void isInsertORUpdateLogic(List<Transaction__c> newRecords,List<Transaction__c> oldRecords, Boolean isInsert, Boolean isUpdate){
        
        set<id> Ids = new set<id>();
        
        //This list will keep the final version of expense records that need to modify
        List<expense__c> updateExpense = new List<expense__c>();
        
        //This list will keep the final version of revenue records that need to modify
        List<revenue__c> updateRevenue = new List<revenue__c>();
        
        //This map will contain the Unique ID either revenue or expense against the amount.
        Map<Id,decimal> mapRevenueExpenseIDToTotalAmount = new Map<Id,Decimal>();
        
        Map<Id,decimal> mapRevenueExpenseIDToTotalAmountOld = new Map<Id,Decimal>();
        //it should be run just for update condition.
        String OldAmountKey = '';
        for(Transaction__c t :  oldRecords)
        {
            if(t.revenue__c==null && t.expense__c!=null)
            {
                OldAmountKey = t.expense__c; 
            }
            else if(t.expense__c==null && t.revenue__c!=null)
            {
                OldAmountKey = t.revenue__c;
            }
            mapRevenueExpenseIDToTotalAmountOld.put(OldAmountKey, t.Amount__c);
            
        }
        
        
        String Key = '';
        for(Transaction__c t : newRecords)
        {
            System.debug('###Trans' + Trigger.oldmap);
            if(t.revenue__c==null && t.expense__c!=null)
            {
                Key = t.expense__c; 
            }
            else if(t.expense__c==null && t.revenue__c!=null)
            {
                Key = t.revenue__c;
            }
            else if(t.expense__c==null && t.revenue__c==null)
            {
                t.addError('Both Expense and Revenue can not be NULL at the same time');
            }
            else
                t.addError('Both Expense and Revenue can not have values at the same time');
            
            
            if(String.isNotBlank(Key))
            {
                Ids.add(t.revenue__c);
                Ids.add(t.expense__c); 
                mapRevenueExpenseIDToTotalAmount.put(Key, t.Amount__c);
            }
            
        }
        
        System.debug('###New Map' + mapRevenueExpenseIDToTotalAmount);
        
        List<expense__c> lstExpense = [select id, Total_Transactions__c,Total_Amount_Of_Expanse__c from expense__C where id in :Ids];
        for(expense__c e :lstExpense)
        {
            if( isInsert){
                if(e.Total_Transactions__c==null)
                {
                    e.Total_Transactions__c =0;
                }
                
                e.Total_Transactions__c = e.Total_Transactions__c + 1;
                
                IF( e.Total_Amount_Of_Expanse__c==NULL){
                    e.Total_Amount_Of_Expanse__c=0;
                }
                e.Total_Amount_Of_Expanse__c = e.Total_Amount_Of_Expanse__c + mapRevenueExpenseIDToTotalAmount.get(e.id);
            }
            
            If(isUpdate)
            {
                system.debug('###Total amount'+e.Total_Amount_Of_Expanse__c);
                IF( e.Total_Amount_Of_Expanse__c==NULL){
                    e.Total_Amount_Of_Expanse__c=0;
                }
                //Decimal Difference = Math.abs(e.Total_Amount_Of_Expanse__c-mapRevenueExpenseIDToTotalAmount.get(e.id));
                //e.Total_Amount_Of_Expanse__c = mapRevenueExpenseIDToTotalAmount.get(e.id) + Difference ;
                
                Decimal oldAmount = mapRevenueExpenseIDToTotalAmountOld.get(e.Id);
                Decimal Difference = Math.abs(e.Total_Amount_Of_Expanse__c-oldAmount);
                e.Total_Amount_Of_Expanse__c = mapRevenueExpenseIDToTotalAmount.get(e.id) + Difference ;
            }
            updateExpense.add(e);
        }
        List<revenue__c> lstRevenue = [select id, Total_Transactions__c,Total_Amount_Of_Revenue__c from revenue__C where id in :Ids];
        for(revenue__c r :lstRevenue)
        {
            if(trigger.isInsert){
                if(r.Total_Transactions__c==null)
                {
                    r.Total_Transactions__c =0;
                }
                r.Total_Transactions__c = r.Total_Transactions__c + 1;
                
                IF( r.Total_Amount_Of_Revenue__c==NULL){
                    r.Total_Amount_Of_Revenue__c=0;
                }
                System.debug('##mapRevenueExpenseIDToTotalAmount'+mapRevenueExpenseIDToTotalAmount.get(r.id));
                System.debug('##Total_Amount_Of_Revenue__c'+r.Total_Amount_Of_Revenue__c);
                System.debug('##Total_Transactions__c'+r.Total_Transactions__c);
                r.Total_Amount_Of_Revenue__c = r.Total_Amount_Of_Revenue__c + mapRevenueExpenseIDToTotalAmount.get(r.id);
                System.debug('##Total_Amount_Of_Revenue__c'+r.Total_Amount_Of_Revenue__c);
                updateRevenue.add(r);
                System.debug('##updateRevenue12'+updateRevenue);
            }
            If(Trigger.IsUpdate)
            {
                
                IF( r.Total_Amount_Of_Revenue__c==NULL){
                    r.Total_Amount_Of_Revenue__c=0;
                }
                
                //Old Logic
                //Decimal Difference = Math.abs(r.Total_Amount_Of_Revenue__c-mapRevenueExpenseIDToTotalAmount.get(r.id));
                // r.Total_Amount_Of_Revenue__c = mapRevenueExpenseIDToTotalAmount.get(r.id) + Difference ;
                
                
                //New Logic
                Decimal oldAmount = mapRevenueExpenseIDToTotalAmountOld.get(r.Id);
                Decimal Difference = Math.abs(r.Total_Amount_Of_Revenue__c-oldAmount);
                r.Total_Amount_Of_Revenue__c = mapRevenueExpenseIDToTotalAmount.get(r.id) + Difference ;
                updateRevenue.add(r);
            }
            
            
        }
        System.debug('##updateRevenue'+updateRevenue);
        System.debug('##updateExpense'+updateExpense);  
        
        If(updateRevenue.size() > 0)
        {
            update updateRevenue;
        }
        If(updateExpense.size() > 0)
        {
            update updateExpense;
        } 
    }
}