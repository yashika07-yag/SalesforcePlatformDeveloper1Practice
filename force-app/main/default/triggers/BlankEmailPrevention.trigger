trigger BlankEmailPrevention on Contact(Before insert){
    
    for(Contact con: Trigger.new){
        if(con.email == ' ' || con.email == null){
            con.adderror('Email is blank.Please enter a valid email.');
        }
    }
}