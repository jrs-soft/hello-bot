public with sharing class ServiceContractService {
    
    public static Quote__c generateQuote(String serviceName, Id contactId) {
        
        if (String.isBlank(contactId) || contactId.toString().length() < 15) {
            throw new ServiceContractException('ContactId inválido.');
        }
        
        Service__c svc = ServiceContractRepository.getServiceByName(serviceName);
        if (svc == null) {
            throw new ServiceContractException('Serviço não encontrado');
        }
        
        Decimal price = svc.BasePrice__c != null ? svc.BasePrice__c : 200;
        
        Quote__c quote = new Quote__c(
            Customer__c = contactId,
        Service__c = svc.Id,
        Price__c = price,
        Status__c = 'Pending'
            );
        insert quote;
        
        return quote;
    }
}