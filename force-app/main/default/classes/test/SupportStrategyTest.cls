@isTest
private class SupportStrategyTest {
    @isTest static void testSupport() {
        BotController.BotRequest req = new BotController.BotRequest();
        req.userId = UserInfo.getUserId();
        req.action = 'Suporte Técnico';
        req.payloadJson = '{"issueType":"Bug","description":"Erro na tela X"}';

        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        BotController.processBot(requests);

        Integer count = [SELECT COUNT() FROM InteractionLog__c WHERE Action__c = 'Suporte Técnico'];
        System.assertEquals(1, count, 'Deveria ter salvo um log de suporte.');
    }
}
