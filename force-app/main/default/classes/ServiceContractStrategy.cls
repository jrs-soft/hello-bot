public with sharing class ServiceContractStrategy implements BotStrategy {
    public BotResponse handle(BotRequestGlobal request) {
        String requestedService = (String) request.parameters.get('serviceName');
        
        if (String.isBlank(requestedService)) {
            return new BotResponse('Por favor, informe qual serviço deseja contratar.');
        }
        
        try {

            System.debug('>>> contactId: ' + request.contactId);
            System.debug('>>> requestedService: ' + requestedService);
            
            Quote__c quote = ServiceContractService.generateQuote(requestedService, request.contactId);
            
            // log
            InteractionLogger.log(
                request.contactId,
                'ServiceContract',
                JSON.serialize(request.parameters),
                'OK'
            );
            
            return new BotResponse(
                'Orçamento gerado para o serviço ' + quote.Service__c + 
                ' no valor de R$' + quote.Price__c
            );
        } catch(ServiceContractException ex) {
            return new BotResponse('Serviço não encontrado. Por favor verifique o nome.');
        }
    }
}
