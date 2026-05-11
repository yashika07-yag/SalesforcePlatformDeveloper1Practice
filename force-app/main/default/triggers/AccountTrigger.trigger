Trigger AccountTrigger on Account (after insert, after update){
    if(Trigger.isAfter){
        AccountHandler.handleAfterUpsert(Trigger.new);
    }
}