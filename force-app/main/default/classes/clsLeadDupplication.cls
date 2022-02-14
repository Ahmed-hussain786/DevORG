public with sharing class clsLeadDupplication 
{
static set<string> leadEmails= new set<string>();
static map<string,Lead> mapLeads=new map<string,Lead>();
static List<Contact> updateContact = new List<Contact>();

public void LeadDupplicationProcess(List<Lead> leads)
{

//Map<String, Contact> updateContactMap = new Map<String, Contact>();

for(Lead l:leads)
{
if(l.Email != null || String.isNotBlank(l.Email)) {
    leadEmails.add(l.Email);
    mapLeads.put(l.Email,l);
    
}
}
system.debug('@@@'+leadEmails);
system.debug('@@@map'+mapLeads);
}
public static void updateContactsRecord(map<string,Lead> mapLeads) {

List<Contact> Contacts=[Select id,Email,FirstName,LastName,MobilePhone,AccountId FROM Contact where Email=:leadEmails];

system.debug('@@@map'+Contacts.size());
if (Contacts.size()!=null ||Contacts.size()>0) {
for (Lead newLead : mapLeads.values()) {
    // Contact con =new Contact();
    for (Contact con : Contacts) {
    con.FirstName=newLead.FirstName;
    con.LastName=newLead.LastName;
    con.Email=newLead.Email;
    con.MobilePhone=newLead.MobilePhone;
    
    updateContact.add(con);
    // updateContactMap.put(newLead.Email, con);
    }

}

}
system.debug('@@@map'+updateContact);
update updateContact;

}



}