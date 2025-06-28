@isTest
public class ReturnPolicyStrategyTest {
    
    @isTest
    static void testHandleReturnPolicy() {
        BotController.BotRequest req = new BotController.BotRequest();
        req.userId = UserInfo.getUserId();
        req.action = 'Politica de Devolucao';
        req.payloadJson = '{"orderId":"999999","reason":"Produto com defeito","startReturn":true}';

        
        Test.startTest();
        new ReturnPolicyStrategy().handle(req);
        Test.stopTest();
        
        // valida se o retorno foi salvo no objeto personalizado
        List<ReturnRequest__c> requests = [
            SELECT Id, OrderId__c, Reason__c, Status__c, UserId__c
            FROM ReturnRequest__c
            WHERE OrderId__c = '999999'
        ];
        
        System.assertEquals(1, requests.size(), 'Deveria ter 1 solicitação de devolução cadastrada');
        System.assertEquals('Produto com defeito', requests[0].Reason__c);
    }
}
