public class ReturnPolicyStrategy implements BotStrategy {
    
    public void handle(BotController.BotRequest req) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);

        String orderId = (String) payload.get('orderId');
        String reason = (String) payload.get('reason');
        Boolean startReturn = (Boolean) payload.get('startReturn');
        if (startReturn == null) {
            startReturn = false;
        }

        ReturnPolicyService service = new ReturnPolicyService();
        String policyText = service.getPolicy();

        if (startReturn) {
            String protocol = service.createReturnRequest(orderId, reason, req.userId);
            InteractionLogger.log(
                req.userId,
                req.action,
                req.payloadJson,
                'Return initiated, protocol: ' + protocol
            );
            System.debug('Devolução iniciada para pedido ' + orderId + ' - protocolo: ' + protocol);
        } else {
            InteractionLogger.log(
                req.userId,
                req.action,
                req.payloadJson,
                'Return policy explained'
            );
            System.debug('Política de devolução informada ao cliente: ' + policyText);
        }
    }
}
