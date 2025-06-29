public with sharing class SupportStrategy implements BotStrategy {
    public BotResponse handle(BotRequestGlobal req) {
        
        // extrai parâmetros diretamente do Map
        String issueType = (String) req.parameters.get('issueType');
        String description = (String) req.parameters.get('description');
        
        // chama o serviço para criar o case
        SupportService supportService = new SupportService();
        String caseNumber = supportService.createCase(req.contactId, issueType, description);
        
        // log no InteractionLogger
        InteractionLogger.log(
            req.contactId,
            'Support',
            JSON.serialize(req.parameters),
            'Protocolo: ' + caseNumber
        );
        
        System.debug('Ticket de suporte aberto: ' + issueType + ' - ' + description + ' - Protocolo: ' + caseNumber);
        
        return new BotResponse(
            'Protocolo ' + caseNumber + ' gerado para sua solicitação de suporte.'
        );
    }
}
