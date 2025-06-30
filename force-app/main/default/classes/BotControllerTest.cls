@isTest
public class BotControllerTest {
    
    @isTest
    static void testProcessBot_Rastreamento() {
        Account acc = new Account(Name='Cliente Rastreio');
        insert acc;
        
        Contact contact = new Contact(LastName='Track', AccountId=acc.Id);
        insert contact;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Rastreamento de Pedido';
        req.sessionId = 'sess1';
        req.contactId = contact.Id;
        req.orderId = '123';
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        Test.startTest();
        List<BotResponseWrapper> responses = BotController.processBot(requests);
        Test.stopTest();
        
        System.assertEquals(1, responses.size());
        System.assert(
            responses[0].responseMessage.toLowerCase().contains('pedido'), 
            'Deveria conter a palavra pedido.'
        );
    }
    
    @isTest
    static void testProcessBot_SuporteTecnico() {
        Contact contact = new Contact(LastName='Suporte');
        insert contact;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Suporte Técnico';
        req.sessionId = 'sess2';
        req.contactId = contact.Id;
        req.description = 'Problema X';
        req.issueType = 'Tipo Y';
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        List<BotResponseWrapper> responses = BotController.processBot(requests);
        
        System.assertEquals(1, responses.size());
        System.assert(responses[0].responseMessage != null);
    }
    
    @isTest
    static void testProcessBot_PoliticaDevolucao() {
        Contact contact = new Contact(LastName='ClienteDevolucao');
        insert contact;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Política de Devolução';
        req.sessionId = 'sess3';
        req.contactId = contact.Id;
        req.orderId = '321';
        req.reason = 'Produto com defeito';
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        List<BotResponseWrapper> responses = BotController.processBot(requests);
        
        System.assertEquals(1, responses.size());
        System.assert(responses[0].responseMessage != null);
    }
    
    @isTest
    static void testProcessBot_ContratacaoServico() {
        Contact contact = new Contact(LastName='ClienteServico');
        insert contact;
        
        Service__c svc = new Service__c(Name='Serviço Premium', BasePrice__c=100);
        insert svc;
        
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Contratação de Serviço';
        req.sessionId = 'sess4';
        req.contactId = contact.Id;
        req.requestedService = 'Serviço Premium';
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        List<BotResponseWrapper> responses = BotController.processBot(requests);
        
        System.assertEquals(1, responses.size());
        System.assert(
            responses[0].responseMessage.toLowerCase().contains('orçamento'), 
            'Deveria conter orçamento.'
        );
    }
    
    @isTest
    static void testProcessBot_ActionInvalida() {
        BotController.BotRequest req = new BotController.BotRequest();
        req.action = 'Ação Inexistente';
        req.sessionId = 'sess5';
        req.contactId = UserInfo.getUserId();
        
        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        
        Test.startTest();
        try {
            BotController.processBot(requests);
            System.assert(false, 'Deveria lançar exceção');
        } catch (BotFactory.BotFactoryException ex) {
            System.assert(ex.getMessage().contains('Nenhuma estratégia'), 'Mensagem de exceção inesperada');
        }
        Test.stopTest();
    }
}
