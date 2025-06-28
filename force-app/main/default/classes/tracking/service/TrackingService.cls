public class TrackingService {
    
    private TrackingRepository repository = new TrackingRepository();
    
    public TrackingResult trackOrder(String orderId, String userId) {
        
        // simula API externa (exemplo de mock callout)
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:OrderTrackingAPI/orders/' + orderId);
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() != 200) {
            throw new TrackingException('Erro ao consultar pedido');
        }
        
        Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        String status = (String) apiResponse.get('status');
        String deliveryDate = (String) apiResponse.get('deliveryDate');
        
        // salva histórico no repositório
        repository.saveTracking(orderId, userId, status, deliveryDate);
        
        return new TrackingResult(status, deliveryDate);
    }
    
    public class TrackingException extends Exception {}
}
