@isTest
private class TrackingStrategyTest {
    @isTest static void testTracking() {
        BotController.BotRequest req = new BotController.BotRequest();
        req.userId = UserInfo.getUserId();
        req.action = 'Rastreamento de Pedido';  // <- corrigido
        req.payloadJson = '{"orderId":"123","orderStatus":"InProgress","items":[]}';

        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        BotController.processBot(requests);

        Integer count = [SELECT COUNT() FROM InteractionLog__c WHERE Action__c = 'Rastreamento de Pedido'];
        System.assertEquals(1, count, 'Deveria ter salvo um log de rastreamento.');
    }
}
