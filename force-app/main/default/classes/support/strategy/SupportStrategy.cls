public class SupportStrategy implements BotStrategy {
    public void handle(BotController.BotRequest req) {
        // parse JSON do payload
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(req.payloadJson);

        String issueType = (String) payload.get('issueType');
        String description = (String) payload.get('description');

        // chama o serviço para criar o case
        SupportService supportService = new SupportService();
        String caseNumber = supportService.createCase(req.userId, issueType, description);

        // log no InteractionLogger
        InteractionLogger.log(
            req.userId,
            req.action,
            req.payloadJson,
            'Support ticket opened: ' + issueType + ' - Protocol: ' + caseNumber
        );

        System.debug('Ticket de suporte aberto: ' + issueType + ' - ' + description + ' - Protocolo: ' + caseNumber);
    }
}
