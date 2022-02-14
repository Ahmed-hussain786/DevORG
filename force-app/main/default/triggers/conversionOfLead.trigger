trigger conversionOfLead on Lead (after insert) {
    
    LeadStatus convertStatus=[select MasterLabel from LeadStatus where isConverted = true limit 1];
    
    List<Database.LeadConvert> leadconverts=new List<Database.LeadConvert>();
    For(Lead lead:Trigger.new){
        if(!lead.isConverted){
            Database.LeadConvert lc=new Database.LeadConvert();
            string opportunityName=lead.Name;
            lc.setLeadId(lead.id);
            //lc.setAccountid(Accountid);//you can the account id insted of create a <spam id>
            lc.setsendNotificationEmail(False);
            lc.setdonotcreateOpportunity(True);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            leadConverts.add(lc);
        }
    }
    if(!leadConverts.isEmpty()){
        List<Database.leadConvertResult>lcr=Database.convertLead(leadConverts);
    }
}