@IsTest
public class GenericRESTMockResponse implements HttpCalloutMock {

    /**@description The response to return */
    HttpResponse res;
    /**@description A map of responses to return based either on the endpoint or request body contents */
    Map<String, HttpResponse> responseByEndpointOrContent;
	
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Constructor
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param   response                       The HttpResponse to return if the mapped responses is 
    * 										  null or finds no match
    * @return  responseByEndpointOrContent    The map of responses to return with either the endpoint
    * 										  or response body part as the keys
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public GenericRESTMockResponse(HttpResponse response, Map<String, HttpResponse> responseByEndpointOrContent) {
        res = response;
        this.responseByEndpointOrContent = responseByEndpointOrContent;
    }
	
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * HttpCalloutMock Interface method to return the response
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param   req   	 		HttpCalloutMock Interface method to return the response
    * @return  HttpResponse     The Response
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public HttpResponse respond(HttpRequest req) {

        if (responseByEndpointOrContent == null) {
            return res;
        }
        else {
            //The if and for can be reordered to fit your needs based on what you want to match on first
            if (responseByEndpointOrContent.containsKey(req.getEndpoint())) {
                return responseByEndpointOrContent.get(req.getEndpoint());
            }

            for (String bodyPart : responseByEndpointOrContent.keySet()) {
                if (req.getBody() != null && req.getBody().containsIgnoreCase(bodyPart)) {
                    return responseByEndpointOrContent.get(bodyPart);
                }
            }

        }
        //No matches, just return the default response (First 3 params of the GenericRESTMockResponse constructor
        return res;
    }
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Set the Mock to return basic response with the specified parameters
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param statusCode 	Response Status Code
    * @param status 		Response Status
    * @param body  			Response Body
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    
    public static void setTestMockResponse(Integer statusCode, String status, String body) {
        setTestMockResponse(statusCode, status, body, null);
    }
	
    
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Set the Mock to return basic response OR a constructed response based on the mapped endpoint 
    * or request body content
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param statusCode 					Response Status Code
    * @param status 						Response Status
    * @param body  							Response Body
    * @param responseByEndpointOrContent 	Map of responses to return with either the endpoint or 
    * 										request body part as the key
    * @return Void
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void setTestMockResponse(Integer statusCode, String status, String body, Map<String, HttpResponse> responseByEndpointOrContent) {
        HttpResponse mockResp = new HttpResponse();

        if (statusCode != null) {
            mockResp.setStatusCode(statusCode);
        }

        if (status != null) {
            mockResp.setStatus(status);
        }

        if (body != null) {
            mockResp.setBody(body);
        }

        test.setMock(
                HttpCalloutMock.class,
                new GenericRESTMockResponse(mockResp, responseByEndpointOrContent)
        );

    }
}