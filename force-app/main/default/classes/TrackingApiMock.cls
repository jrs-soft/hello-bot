@IsTest
global class TrackingApiMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"status":"Entregue","deliveryDate":"2025-07-01"}');
        return res;
    }
}