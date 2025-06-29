public with sharing class TrackingStrategy implements BotStrategy {

    /**
     * Implementa a estratégia de rastreamento de pedidos
     * seguindo a interface BotStrategy
     */
    public BotResponse handle(BotRequestGlobal request) {

        System.debug('>>> TrackingStrategy executado: ' + request);
        
        // simula status de rastreamento
        String trackingStatus = 'Seu pedido está a caminho!';

        // registra a interação no log
        InteractionLogger.log(
            request.contactId,
            'Tracking',
            JSON.serialize(request.parameters),
            'OK'
        );
        
        // devolve resposta ao bot
        return new BotResponse(trackingStatus);
    }
}
