@IsTest
global class LogisticsApiMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"status":"em trânsito"}');
        return res;
    }
}
