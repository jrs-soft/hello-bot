public with sharing class ReturnPolicyStrategy implements BotStrategy {
    
    public BotResponse handle(BotRequestGlobal req) {
        // extrai do parameters
        String orderId = (String) req.parameters.get('orderId');
        String reason = (String) req.parameters.get('reason');
        Boolean startReturn = (Boolean) req.parameters.get('startReturn');
        
        if (startReturn == null) {
            startReturn = false;
        }
        
        ReturnPolicyService service = new ReturnPolicyService();
        String policyText = service.getPolicy();
        
        if (startReturn) {
            String protocol = service.createReturnRequest(orderId, reason, req.contactId);
            InteractionLogger.log(
                req.contactId,
                'ReturnPolicy',
                JSON.serialize(req.parameters),
                'Return initiated, protocol: ' + protocol
            );
            System.debug('Devolução iniciada para pedido ' + orderId + ' - protocolo: ' + protocol);
            
            return new BotResponse(
                'Sua solicitação de devolução foi registrada. Protocolo: ' + protocol
            );
        } else {
            InteractionLogger.log(
                req.contactId,
                'ReturnPolicy',
                JSON.serialize(req.parameters),
                'Return policy explained'
            );
            System.debug('Política de devolução informada ao cliente: ' + policyText);
            
            return new BotResponse(
                'Política de devolução: ' + policyText
            );
        }
    }
}
