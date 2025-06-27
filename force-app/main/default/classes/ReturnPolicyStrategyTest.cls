@isTest
private class ReturnPolicyStrategyTest {
    @isTest static void testReturnPolicy() {
        BotController.BotRequest req = new BotController.BotRequest();
        req.userId = UserInfo.getUserId();
        req.action = 'Política de Devolução';
        req.payloadJson = '{"orderId":"5555","reason":"Produto com defeito"}';

        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        BotController.processBot(requests);

        Integer count = [SELECT COUNT() FROM InteractionLog__c WHERE Action__c = 'Política de Devolução'];
        System.assertEquals(1, count, 'Deveria ter salvo um log de devolução.');
    }
}
