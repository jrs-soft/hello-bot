@isTest
public class ReturnPolicyStrategyTest {
    
    @isTest
    static void testHandleReturnPolicy() {
        // arrange
        Account acc = new Account(Name = 'Cliente Retorno');
        insert acc;
        
        Contact contact = new Contact(
            LastName = 'Cliente Devolucao',
            AccountId = acc.Id
        );
        insert contact;
        
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Política de Devolução',
            'orderId' => '999999',
            'reason' => 'Produto com defeito',
            'startReturn' => true
        };
        req.contactId = contact.Id;
        req.sessionId = 'sess999';
        
        // act
        Test.startTest();
        BotResponse res = new ReturnPolicyStrategy().handle(req);
        Test.stopTest();
        
        // assert
        System.assertNotEquals(null, res, 'Deveria haver resposta do bot');
        System.assert(res.message.contains('Protocolo'), 'A resposta deveria conter o protocolo de devolução');
        
        List<ReturnRequest__c> requests = [
            SELECT Id, OrderId__c, Reason__c, Status__c, UserId__c
            FROM ReturnRequest__c
            WHERE OrderId__c = '999999'
        ];
        
        System.assertEquals(1, requests.size(), 'Deveria ter 1 solicitação de devolução cadastrada');
        System.assertEquals('Produto com defeito', requests[0].Reason__c);
    }
}
