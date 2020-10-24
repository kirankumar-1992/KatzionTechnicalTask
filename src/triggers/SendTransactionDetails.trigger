/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Trigger on Transaction Item to invoke the API to send transaction and related items detail when
* the number of transaction items that are part of the same transaction are equal to the 
* 'Transaction Count' field in the transaction record
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
trigger SendTransactionDetails on TransactionItem__c (after insert) {
    //firing the helper method
	SendTransactionDetails_Helper.afterInsertHandler(trigger.new);	 
}