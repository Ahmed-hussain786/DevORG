trigger triDupplicateEmailUpdate on Lead (before insert) {
    if (trigger.isInsert&&trigger.isBefore){
clsLeadDupplication obj=new clsLeadDupplication();
    obj.LeadDupplicationProcess(trigger.new);
    }
}