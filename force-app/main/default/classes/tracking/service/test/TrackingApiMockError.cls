@IsTest
global class TrackingApiMockError implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);
        res.setBody('{"message":"Internal Error"}');
        return res;
    }
}