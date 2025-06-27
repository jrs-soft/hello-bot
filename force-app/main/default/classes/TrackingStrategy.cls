public class TrackingStrategy implements BotStrategy {
    
    public void handle(BotController.BotRequest req) {
        // parse JSON
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);
        
        String orderId = (String) payload.get('orderId');
        String status  = (String) payload.get('orderStatus');
        String deliveryDate = (String) payload.get('deliveryDate');
        
        InteractionLogger.log(
            req.userId,
            req.action,
            req.payloadJson,
            'Processed: ' + status
        );
        
        System.debug('Rastreamento do pedido ' + orderId + ' com status ' + status + ' e entrega em ' + deliveryDate);
    }
}