public class ReturnPolicyStrategy implements BotStrategy {
    public void handle(BotController.BotRequest req) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);

        String orderId = (String) payload.get('orderId');
        String reason  = (String) payload.get('reason');

        InteractionLogger.log(
            req.userId,
            req.action,
            req.payloadJson,
            'Return initiated'
        );

        System.debug('Devolução iniciada para o pedido ' + orderId + ' motivo: ' + reason);
    }
}
