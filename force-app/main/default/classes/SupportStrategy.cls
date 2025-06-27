public class SupportStrategy implements BotStrategy {
    public void handle(BotController.BotRequest req) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);
        
        String issueType = (String) payload.get('issueType');
        String description = (String) payload.get('description');

        InteractionLogger.log(
            req.userId,
            req.action,
            req.payloadJson,
            'Support ticket opened: ' + issueType
        );

        System.debug('Ticket de suporte aberto: ' + issueType + ' - ' + description);
    }
}
