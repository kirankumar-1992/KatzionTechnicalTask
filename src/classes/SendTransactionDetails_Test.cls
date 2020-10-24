@isTest
private class SendTransactionDetails_Test {
    @Testsetup
    public static void createTestData(){
    	Transaction__c transactionRecord = new Transaction__c();
        transactionRecord.Total_Cost__c =300;
        transactionRecord.Total_Discount__c =200;
        transactionRecord.Transaction_Count__c =3;
        transactionRecord.Name='Tran 001';
        insert transactionRecord;
        
        list<TransactionItem__c> TransactionItemList = new list<TransactionItem__c>();
        TransactionItem__c TransactionItem = new TransactionItem__c();
        TransactionItem.Transaction__c=transactionRecord.Id;
        TransactionItem.Item_Cost__c=200;
        TransactionItem.Name='TranItem 001';
        TransactionItemList.add(TransactionItem);
        
        TransactionItem__c TransactionItem1 = new TransactionItem__c();
        TransactionItem1.Transaction__c=transactionRecord.Id;
        TransactionItem1.Item_Cost__c=100;
        TransactionItem1.Name='TranItem 002';
        TransactionItemList.add(TransactionItem1);
        insert TransactionItemList;
        
    }
    /*case 1: Getting positive response for both the api and details sucessfully submitted*/
    @isTest
    private static void testPostiveScenario(){
        HttpResponse transactionResponse = new HttpResponse();
        transactionResponse.setStatusCode(200);
        transactionResponse.setBody('{"values":{"TransactionDate":"2020-10-25","TotalDiscount":"100.00","TotalCount":"3","TotalCost":"200.00"},"keys":{"TransactionItemID":"a012w00000XXA3rAAH"}}');
        
        HttpResponse transactionItemResponse = new HttpResponse();
        transactionItemResponse.setStatusCode(200);
        transactionItemResponse.setBody('{"values":{"ItemName":"Transaction Item 2","ItemCost":"100.00"},"keys":{"TransactionItemID":"a002w00000DKwqGAAT"}},{"values":{"ItemName":"transaction Item 1","ItemCost":"100.00"},"keys":{"TransactionItemID":"a002w00000DKwqBAAT"}}');
        
        Map<String, HttpResponse> responseByBodyContent = new Map<String, HttpResponse>{'callout:TransactionAPI/sendtransaction' => transactionResponse,
            'callout:TransactionAPI/sendtransactionItem'=>transactionItemResponse};
                GenericRESTMockResponse.setTestMockResponse(404, 'Not Authorized', 'test1222', responseByBodyContent);
        Transaction__c TransactionV =[select id from Transaction__c];
        test.startTest();
        TransactionItem__c TransactionItem = new TransactionItem__c();
        TransactionItem.Transaction__c=TransactionV.Id;
        TransactionItem.Item_Cost__c=100;
        TransactionItem.Name='TranItem 003';
        insert TransactionItem;
        test.stopTest();
    }
    
    /*case 2: Getting negative response for transaction the api and verifying the transaction item API is not invoked*/
    @isTest
    private static void testNegativeScenario(){
        HttpResponse transactionItemResponse = new HttpResponse();
        transactionItemResponse.setStatusCode(400);
        transactionItemResponse.setBody('');
        
       
        Map<String, HttpResponse> responseByBodyContent = new Map<String, HttpResponse>{'callout:TransactionAPI/sendtransactionItem' => transactionItemResponse};
        GenericRESTMockResponse.setTestMockResponse(404, 'Not Authorized', 'test1222', responseByBodyContent);
        Transaction__c TransactionV =[select id from Transaction__c];
        test.startTest();
        TransactionItem__c TransactionItem = new TransactionItem__c();
        TransactionItem.Transaction__c=TransactionV.Id;
        TransactionItem.Item_Cost__c=100;
        TransactionItem.Name='TranItem 003';
        insert TransactionItem;
        test.stopTest();
    }
}