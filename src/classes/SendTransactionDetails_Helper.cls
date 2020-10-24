/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Trigger helper for SendTransactionDetails trigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Kiran
* @maintainedBy   Kiran
* @created        24-10-2020
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            Kiran
* 24-10-2020      Intial version
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class SendTransactionDetails_Helper {
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This is after insert handler which process the transaction item record and invoke the API 
    * helper method of business condition is satisfied
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    triggerNew   contains list of TransactionItem inserted
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void afterInsertHandler(list<TransactionItem__c> triggerNew){
        //To store all the Transaction record Ids related to the transaction items created 
    	set<id> transactionIds = new set<id>();
        //To store transaction record details for which business criteria is satisfied and need to send the details through API
        list<Transaction__c> TransactionToProcess = new list<Transaction__c>();
        for(TransactionItem__c tranItem : triggerNew){
        	transactionIds.add(tranItem.Transaction__c);    
        }
        // Getting all transaction details and related items based on the transactionIds
        map<id,Transaction__c> transactionMap = new map<id,Transaction__c>([select id,Total_Cost__c,Total_Discount__c,createdDate,Transaction_Count__c,
                                                                            (select id,Item_Cost__c,Name from TransactionItem__r) from Transaction__c where id In : transactionIds]);
        for(id transactionId :  transactionMap.keyset()){
            Transaction__c TransactionDetail = transactionMap.get(transactionId);
            // Checking the business criteria for sending the details to external system 
            if(TransactionDetail.TransactionItem__r.size() == TransactionDetail.Transaction_Count__c){
                TransactionToProcess.add(TransactionDetail);
            }	 	   
        }
        
        if(TransactionToProcess.size() > 0){
            // firing the Queueable method to process the transaction
        	System.enqueueJob(new SendTransactionQueueable(TransactionToProcess));  
        }
        
    }
}