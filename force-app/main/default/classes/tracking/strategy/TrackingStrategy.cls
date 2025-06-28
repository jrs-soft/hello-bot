public class TrackingStrategy implements BotStrategy {
    
    private TrackingService service = new TrackingService();
    
    public void handle(BotController.BotRequest req) {
        // parse JSON
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);
        
        String orderId = (String) payload.get('orderId');
        
        // delega para a camada de serviço
        TrackingResult result = service.trackOrder(orderId, req.userId);
        
        InteractionLogger.log(
            req.userId,
            req.action,
            JSON.serialize(payload),
            'Processed: ' + result.status
        );
        
        System.debug('Pedido ' + orderId + ' status: ' + result.status + ', entrega prevista: ' + result.deliveryDate);
    }
}
