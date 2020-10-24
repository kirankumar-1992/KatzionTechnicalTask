/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Utilty class for sendtransaction module
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
public class SendTransactionUtility {
	/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method used to invoke HTTP callout.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param   endPointURL     API end point URL.
    * @param   methodType      Method type Example: POST, GET, PUT..
    * @param   requestBody     request body of the API.
    * @return  HttpResponse    response of the API.
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static HttpResponse invokeHTTPCallout(String endPointURL,string methodType,string requestBody){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPointURL);
            request.setMethod(methodType);
            request.setHeader('Content-Type', 'application/json');
            if(string.isNotBlank(requestBody)){
                request.setBody(requestBody);
            }
            request.setTimeout(120000);
            HttpResponse apiResponse  = http.send(request);
            return apiResponse;
        }
        catch(exception e){
            //error handling
            return null;
        }
    } 
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method used to create JSON request for Transaction HTTP callout.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param   TransactionDetails     Transaction Details.
    * @return  string                 request body for the API.
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static string createTransactionRequestBody(Transaction__c TransactionDetails){
        string JSONRequest='';
        transactionWrapper transactionReq = new transactionWrapper();
        transactionReq.keys= new keysWrapper(TransactionDetails.id);
        transactionReq.values= new TransactionValueWrapper(string.valueof(TransactionDetails.Total_Cost__c),string.valueof(TransactionDetails.Total_Discount__c),string.valueof(TransactionDetails.createdDate.date()),string.valueof(TransactionDetails.Transaction_Count__c));
        JSONRequest = JSON.serialize(transactionReq);
        return JSONRequest;
    }
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method used to create JSON request for Transaction Item HTTP callout.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param   TransactionItems       Transaction Items.
    * @return  string                 request body for the API.
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static string createTransactionItemRequestBody(list<TransactionItem__c> TransactionItems){
        string JSONRequest='';
        list<transactionItemWrapper> transactionItemRequest = new list<transactionItemWrapper>();
        for(TransactionItem__c tran : TransactionItems){
        	transactionItemWrapper transactionItemReq = new transactionItemWrapper();
            transactionItemReq.keys= new keysWrapper(tran.id);
            transactionItemReq.values= new TransactionItemValueWrapper(string.valueof(tran.Item_Cost__c),tran.Name);
            transactionItemRequest.add(transactionItemReq);
        }
        JSONRequest = JSON.serialize(transactionItemRequest);
        return JSONRequest;
    }
    
    
    
    public class transactionItemWrapper{
        public keysWrapper keys;
        public TransactionItemValueWrapper values;
    }
    
    
    public class transactionWrapper{
        public keysWrapper keys;
        public TransactionValueWrapper values;
    }
    
    
    public class keysWrapper{
        public string TransactionItemID;
        public keysWrapper(string TransactionItemID){
            this.TransactionItemID = TransactionItemID;
        }
    }
    
    public class TransactionItemValueWrapper{
        public string ItemCost;
        public string ItemName;
        public TransactionItemValueWrapper(string ItemCost,string ItemName){
            this.ItemCost = ItemCost;
            this.ItemName = ItemName;
        }
    }
    
    public class TransactionValueWrapper{
        public string TotalCost;
        public string TotalDiscount;
        public string TransactionDate;
        public string TotalCount;
        public TransactionValueWrapper(string TotalCost,string TotalDiscount,string TransactionDate,string TotalCount){
            this.TotalCost = TotalCost;
            this.TotalDiscount = TotalDiscount;
            this.TransactionDate = TransactionDate;
            this.TotalCount = TotalCount;
        }
    }
}