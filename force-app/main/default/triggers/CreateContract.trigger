trigger CreateContract on Opportunity (after insert,after update ) {
    handlerContract.createOpportunities(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldmap,trigger.isInsert);        
}