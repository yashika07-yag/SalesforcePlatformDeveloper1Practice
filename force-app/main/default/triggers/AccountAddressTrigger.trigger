trigger AccountAddressTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Check if the "Billing Address" checkbox is true
        if (acc.Match_Billing_Address__c) {
			acc.ShippingPostalCode  = acc.BillingPostalCode;
}
    }
}