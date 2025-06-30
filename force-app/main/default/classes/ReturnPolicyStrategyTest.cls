@isTest
public class ReturnPolicyStrategyTest {
    
    @isTest
    static void testHandle_ReturnPolicyOnly() {
        // arrange
        Contact contact = new Contact(LastName = 'Cliente');
        insert contact;

        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String,Object>{
            'action' => 'Política de Devolução',
            'orderId' => '12345',
            'reason' => 'Defeito'
            // startReturn não informado → default false
        };
        req.sessionId = 'sess-001';
        req.contactId = contact.Id;

        ReturnPolicyStrategy strategy = new ReturnPolicyStrategy();

        // act
        Test.startTest();
        BotResponse res = strategy.handle(req);
        Test.stopTest();

        // assert
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('Política de devolução'), 
                      'Deveria retornar texto da política');
        
        // validar log
        List<InteractionLog__c> logs = [
            SELECT Id, Action__c FROM InteractionLog__c
            WHERE User__c = :contact.Id
            AND Action__c = 'ReturnPolicy'
        ];
        System.assertEquals(1, logs.size(), 'Deveria ter registrado o log de política');
    }
    
    @isTest
    static void testHandle_StartReturnTrue() {
        // arrange
        Contact contact = new Contact(LastName = 'Cliente');
        insert contact;

        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String,Object>{
            'action' => 'Política de Devolução',
            'orderId' => '98765',
            'reason' => 'Produto quebrado',
            'startReturn' => true
        };
        req.sessionId = 'sess-002';
        req.contactId = contact.Id;

        ReturnPolicyStrategy strategy = new ReturnPolicyStrategy();

        // act
        Test.startTest();
        BotResponse res = strategy.handle(req);
        Test.stopTest();

        // assert
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('Protocolo'), 
                      'Deveria confirmar abertura de devolução');
        
        // validar log
        List<InteractionLog__c> logs = [
            SELECT Id, Action__c FROM InteractionLog__c
            WHERE User__c = :contact.Id
            AND Action__c = 'ReturnPolicy'
        ];
        System.assertEquals(1, logs.size(), 'Deveria ter registrado o log de devolução');
    }
    
    @isTest
    static void testHandle_NullReasonAndStartReturn() {
        // arrange
        Contact contact = new Contact(LastName = 'Cliente');
        insert contact;

        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String,Object>{
            'action' => 'Política de Devolução',
            'orderId' => '22222'
            // reason nulo
            // startReturn nulo → default false
        };
        req.sessionId = 'sess-003';
        req.contactId = contact.Id;

        ReturnPolicyStrategy strategy = new ReturnPolicyStrategy();

        // act
        Test.startTest();
        BotResponse res = strategy.handle(req);
        Test.stopTest();

        // assert
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('Política de devolução'), 
                      'Deveria retornar política mesmo sem reason');
    }
}
