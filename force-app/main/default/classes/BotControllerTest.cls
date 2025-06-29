@isTest
public class BotControllerTest {
    
    @isTest
    static void testProcessBot_withServiceContract() {
        // arrange
        Service__c svc = new Service__c(Name = 'Consultoria Premium', BasePrice__c = 500);
        insert svc;
        
        Account acc = new Account(Name = 'Empresa Teste');
        insert acc;
        
        Contact contact = new Contact(LastName = 'Cliente', AccountId = acc.Id);
        insert contact;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Contratação de Serviço';
        req.sessionId = 'sess999';
        req.contactId = contact.Id;
        req.serviceName = 'Consultoria Premium';
        
        // act
        Test.startTest();
        BotController.processBot(new List<BotController.BotRequest>{ req });
        Test.stopTest();
        
        // assert
        List<Quote__c> quotes = [
            SELECT Id FROM Quote__c WHERE Customer__c = :contact.Id
        ];
        System.assertEquals(1, quotes.size(), 'Deveria ter gerado um orçamento.');
    }
    
    @isTest
    static void testProcessBot_withUnknownAction() {
        // arrange
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Ação Inexistente';
        req.sessionId = 'sess123';
        req.contactId = UserInfo.getUserId();
        
        // act + assert
        Test.startTest();
        try {
            BotController.processBot(new List<BotController.BotRequest>{ req });
            System.assert(false, 'Deveria ter lançado exceção para ação inválida.');
        } catch (BotFactory.BotFactoryException ex) {
            System.assert(ex.getMessage().contains('Nenhuma estratégia encontrada'), 'Mensagem de exceção inesperada');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testProcessBot_withTracking() {
        // arrange
        Account acc = new Account(Name = 'Conta teste');
        insert acc;
        
        Contact contact = new Contact(
            FirstName = 'Fulano',
        LastName = 'Teste',
        AccountId = acc.Id
            );
        insert contact;
        
        // cria request do bot
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Rastreamento de Pedido';
        req.sessionId = 'sess123';
        req.contactId = contact.Id;
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        // act
        Test.startTest();
        BotController.processBot(requests);
        Test.stopTest();
        
        // assert
        List<InteractionLog__c> logs = [
            SELECT Id, User__c, Action__c, Status__c 
            FROM InteractionLog__c 
            WHERE User__c = :contact.Id
        ];
        
        System.assertEquals(1, logs.size(), 'Deveria ter registrado o log de rastreamento.');
        System.assertEquals('Tracking', logs[0].Action__c, 'A ação deveria ser Tracking');
        System.assertEquals('OK', logs[0].Status__c, 'Status deveria ser OK');
    }
}