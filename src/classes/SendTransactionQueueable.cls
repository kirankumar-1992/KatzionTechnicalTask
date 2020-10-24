/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Queueable class to send the transaction and related item details to external system through rest
* API
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
public class SendTransactionQueueable implements Queueable,database.allowscallouts {
    public List<Transaction__c> TransactionList ; 
    public SendTransactionQueueable(List<Transaction__c> TransactionList){
        this.TransactionList = TransactionList ;  
    }
    public void execute(QueueableContext context) {
        for(Transaction__c tran :TransactionList){
            //Invoking the send transaction Item API, if the send transaction API is successfull
            HttpResponse sendTransactionItemResponse = SendTransactionUtility.invokeHTTPCallout('callout:TransactionAPI/sendtransactionItem','POST',SendTransactionUtility.createTransactionItemRequestBody(tran.TransactionItem__r));
			
            //Invoking the send transaction API
            if(sendTransactionItemResponse?.getStatusCode() == 200){
                HttpResponse sendTransactionResponse = SendTransactionUtility.invokeHTTPCallout('callout:TransactionAPI/sendtransaction','POST',SendTransactionUtility.createTransactionRequestBody(tran));
            }
        }
    }
}