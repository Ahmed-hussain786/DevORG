public class AssignmentClsAutoLeadConvert {
    @InvocableMethod(label='Convert Lead') 
    Public Static void convertLeads(List<Id>leadIds)
    {
        LeadStatus convertStatus=[select MasterLabel from LeadStatus where isConverted = true limit 1];
        //  List<Lead> leads = new List <Lead>();
        
        List<Database.LeadConvert> leadconverts=new List<Database.LeadConvert>();
        For(Id Ids:leadIds){
            Database.LeadConvert lc=new Database.LeadConvert();
            lc.setLeadId(Ids);
            lc.setsendNotificationEmail(False);
            lc.setdonotcreateOpportunity(True);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            leadConverts.add(lc);
            
        }
        if(!leadConverts.isEmpty()){
            List<Database.leadConvertResult>lcr=Database.convertLead(leadConverts);
        }
    }
    
}