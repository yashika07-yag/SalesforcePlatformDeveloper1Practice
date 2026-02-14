trigger OrderEventTrigger on Order_Event__e (after insert) {
    
    List<Task> Tasks = new List<Task>();
    
    for(Order_Event__e event : Trigger.New){
        if(event.Has_Shipped__c == true){
            Task tsk = new Task();
            tsk.Priority = 'Medium';
            tsk.Subject = 'Follow up on shipped order 105';
            tsk.OwnerId = event.CreatedById;
            tasks.add(tsk);
            
        }
        
    }
    insert Tasks;

}