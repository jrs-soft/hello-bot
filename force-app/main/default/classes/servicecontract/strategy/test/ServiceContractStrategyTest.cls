@isTest
private class ServiceContractStrategyTest {
    @isTest static void testServiceContract() {
        BotController.BotRequest req = new BotController.BotRequest();
        req.userId = UserInfo.getUserId();
        req.action = 'Contratação de Serviço';
        req.payloadJson = '{"contractType":"Gold","startDate":"2025-07-01","duration":"12 meses"}';

        List<BotController.BotRequest> requests = new List<BotController.BotRequest>{ req };
        BotController.processBot(requests);

        Integer count = [SELECT COUNT() FROM InteractionLog__c WHERE Action__c = 'Contratação de Serviço'];
        System.assertEquals(1, count, 'Deveria ter salvo um log de contrato de serviço.');
    }
}
