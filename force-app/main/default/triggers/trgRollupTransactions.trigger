trigger trgRollupTransactions on Transaction__c (after insert,after delete,after update) {
    
    if(Trigger.isDelete)
	{
		TransactionBusinessLogic.IsdeleteLogic(Trigger.old);
	}
	
	if(Trigger.isInsert || Trigger.isUpdate)
	{
		TransactionBusinessLogic.isInsertORUpdateLogic(Trigger.new,Trigger.old,Trigger.IsInsert,Trigger.isUpdate);
	}
 
}