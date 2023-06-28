@isTest
global class mockResponseClass implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest request) 
    {
        String jsonResponse = '{"message":"success","status":200,"data":{"api_key":"BS7MKK-5HFBNJ-78FBJK-NK90FHJ","id":789}}';
        HttpResponse response = new HttpResponse();
        response.setHeader('accept', 'application/json');
        response.setHeader('api_key','6Z3W9SZ-VTW47B7-NFY0CBX-DGH3RGT');
        response.setHeader('Content-Type', 'application/json');  
        response.setBody(jsonResponse);
        return response; 
    }
}