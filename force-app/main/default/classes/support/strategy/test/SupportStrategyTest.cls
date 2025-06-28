@isTest
private class SupportStrategyTest {
    @isTest static void testSupportStrategy() {
        // simula a requisição do bot
        BotController.BotRequest req = new BotController.BotRequest();
        req.userId = '005XXXXXXXXXXXX';
        req.action = 'Suporte Técnico';
        req.payloadJson = '{"issueType":"Falha Login","description":"Não consigo acessar o sistema"}';

        // executa
        SupportStrategy strategy = new SupportStrategy();
        strategy.handle(req);

        // valida se o case foi criado
        List<Case> cases = [SELECT Id, Subject FROM Case WHERE Origin = 'Chatbot'];
        System.assertEquals(1, cases.size(), 'Um caso deveria ter sido criado');
        System.assert(cases[0].Subject.contains('Falha Login'));

        // valida log de interação
        List<InteractionLog__c> logs = [SELECT Id, Status__c FROM InteractionLog__c WHERE Action__c = 'Suporte Técnico'];
        System.assertEquals(1, logs.size(), 'Log deveria ter sido salvo');
    }
}
