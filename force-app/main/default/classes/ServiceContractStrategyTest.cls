@isTest
public class ServiceContractStrategyTest {
    
    @isTest
    static void testHandle_ServiceFound() {
        // arrange
        Account acc = new Account(Name = 'Cliente Teste');
        insert acc;
        
        Contact contact = new Contact(
            LastName = 'Cliente',
            AccountId = acc.Id
        );
        insert contact;
        
        Service__c service = new Service__c(
            Name = 'Suporte Premium',
            BasePrice__c = 150
        );
        insert service;
        
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Contratação de Serviço',
            'requestedService' => 'Suporte Premium'
        };
        req.contactId = contact.Id;
        req.sessionId = 'sess123';
        
        // act
        Test.startTest();
        BotResponse res = new ServiceContractStrategy().handle(req);
        Test.stopTest();
        
        // assert
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('Orçamento gerado'), 'Mensagem deveria confirmar geração do orçamento');
        
        List<Quote__c> quotes = [
            SELECT Id, Price__c, Status__c 
            FROM Quote__c 
            WHERE Customer__c = :contact.Id
        ];
        System.assertEquals(1, quotes.size());
        System.assertEquals(150, quotes[0].Price__c);
        System.assertEquals('Pending', quotes[0].Status__c);
    }
    
    @isTest
    static void testHandle_ServiceNotFound() {
        // arrange
        Account acc = new Account(Name = 'Cliente Teste 2');
        insert acc;
        
        Contact contact = new Contact(
            LastName = 'Cliente 2',
            AccountId = acc.Id
        );
        insert contact;
        
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Contratação de Serviço',
            'requestedService' => 'Serviço Inexistente'
        };
        req.contactId = contact.Id;
        req.sessionId = 'sess456';
        
        // act
        Test.startTest();
        BotResponse res = new ServiceContractStrategy().handle(req);
        Test.stopTest();
        
        // assert
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('não encontrado'), 'Mensagem deveria avisar serviço não encontrado');
    }
}
