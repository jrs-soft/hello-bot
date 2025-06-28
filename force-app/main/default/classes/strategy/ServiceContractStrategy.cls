public class ServiceContractStrategy implements BotStrategy {
    public void handle(BotController.BotRequest req) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);

        String contractType = (String) payload.get('contractType');
        String startDate    = (String) payload.get('startDate');
        String duration     = (String) payload.get('duration');

        InteractionLogger.log(
            req.userId,
            req.action,
            req.payloadJson,
            'Service contract created'
        );

        System.debug('Contrato de serviço criado tipo ' + contractType + ', início ' + startDate + ', duração ' + duration);
    }
}
