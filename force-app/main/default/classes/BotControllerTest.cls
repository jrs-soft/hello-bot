@isTest
public class BotControllerTest {
    
    @isTest
    static void testProcessBot_withServiceContract() {
        // arrange
        Service__c svc = new Service__c(
            Name = 'Consultoria Premium',
            BasePrice__c = 500
        );
        insert svc;
        
        Account acc = new Account(Name = 'Cliente Teste');
        insert acc;
        
        Contact contact = new Contact(
            LastName = 'Fulano',
            AccountId = acc.Id
        );
        insert contact;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Contratação de Serviço';
        req.sessionId = 'sess123';
        req.contactId = contact.Id;
        req.serviceName = 'Consultoria Premium';
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        // act
        Test.startTest();
        List<BotResponseWrapper> responses = BotController.processBot(requests);
        Test.stopTest();
        
        // assert
        System.assertEquals(1, responses.size(), 'Deveria ter retornado uma resposta');
        System.assert(
            responses[0].responseMessage.contains('Orçamento gerado'),
            'A resposta deveria conter mensagem de orçamento'
        );
        
        List<Quote__c> quotes = [
            SELECT Id, Customer__c, Status__c FROM Quote__c
            WHERE Customer__c = :contact.Id
        ];
        System.assertEquals(1, quotes.size(), 'Deveria ter gerado um orçamento');
        System.assertEquals('Pending', quotes[0].Status__c, 'O orçamento deveria estar pendente');
    }
    
    @isTest
    static void testProcessBot_withTracking() {
        // arrange
        Account acc = new Account(Name = 'Cliente Track');
        insert acc;
        
        Contact contact = new Contact(
            LastName = 'Ciclano',
            AccountId = acc.Id
        );
        insert contact;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Rastreamento de Pedido';
        req.sessionId = 'sess999';
        req.contactId = contact.Id;
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        // act
        Test.startTest();
        List<BotResponseWrapper> responses = BotController.processBot(requests);
        Test.stopTest();
        
        // assert
        System.assertEquals(1, responses.size(), 'Deveria ter retornado uma resposta');
        System.assert(
            responses[0].responseMessage.contains('Seu pedido está a caminho'),
            'A resposta deveria conter a mensagem do rastreamento'
        );
        
        List<InteractionLog__c> logs = [
            SELECT Id, Action__c, Status__c
            FROM InteractionLog__c
            WHERE User__c = :contact.Id
            AND Action__c = 'Tracking'
        ];
        System.assertEquals(1, logs.size(), 'Deveria ter salvo o log de rastreamento');
    }
    
    @isTest
    static void testProcessBot_withUnknownAction() {
        // arrange
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Ação Inexistente';
        req.sessionId = 'sess456';
        req.contactId = UserInfo.getUserId();
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        // act + assert
        Test.startTest();
        try {
            BotController.processBot(requests);
            System.assert(false, 'Era esperado exceção para ação desconhecida');
        } catch (BotFactory.BotFactoryException ex) {
            System.assert(ex.getMessage().contains('Nenhuma estratégia'), 'Mensagem inesperada de exceção');
        }
        Test.stopTest();
    }
}
