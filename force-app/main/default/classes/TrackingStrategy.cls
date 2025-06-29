public with sharing class TrackingStrategy implements BotStrategy {
    public BotResponse handle(BotRequestGlobal request) {
        System.debug('>>> TrackingStrategy executado com parâmetros: ' + JSON.serialize(request.parameters));

        String orderId = (String) request.parameters.get('orderId');
        if (String.isBlank(orderId)) {
            return new BotResponse('⚠️ Por favor, informe o número do pedido.');
        }
        
        try {
            TrackingService service = new TrackingService();
            TrackingResult result = service.trackOrder(orderId, request.contactId);

            InteractionLogger.log(
                request.contactId,
                'Tracking',
                JSON.serialize(request.parameters),
                'Status retornado: ' + result.status
            );

            return new BotResponse(
                '✅ Pedido ' + orderId + ' está no status: ' + result.status +
                ' | Entrega prevista: ' + result.deliveryDate
            );
        } catch(Exception e) {
            System.debug('Erro ao consultar pedido no TrackingService: ' + e.getMessage());
            return new BotResponse('⚠️ Desculpe, não consegui consultar seu pedido no momento. Tente mais tarde.');
        }
    }
}
