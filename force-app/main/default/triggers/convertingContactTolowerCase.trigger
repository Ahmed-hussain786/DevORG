trigger convertingContactTolowerCase on Contact (before insert) {
   // List<string>convertCase=new List<string>();
    for (Contact c:trigger.new){
        string cFirstName=c.FirstName;
        string cLastName=c.LastName;
        if(cFirstName!=null){
            c.FirstName=cFirstName.toLowerCase();
        }
        if(cLastName!=null){
            c.LastName=cLastName.toLowerCase();
        }
      // convertCase.add(c.Department);
      //  convertCase.add(c.Title);
        
    }

}