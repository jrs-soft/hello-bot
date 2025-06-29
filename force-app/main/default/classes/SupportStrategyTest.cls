@isTest
private class SupportStrategyTest {
    
    @isTest
    static void testSupportStrategy() {
        // arrange
        Account acc = new Account(Name = 'Empresa Exemplo');
        insert acc;
        
        Contact contact = new Contact(LastName = 'Cliente Suporte', AccountId = acc.Id);
        insert contact;
        
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String,Object>{
            'action' => 'Suporte Técnico',
            'issueType' => 'Falha Login',
            'description' => 'Não consigo acessar o sistema'
        };
        req.contactId = contact.Id;
        req.sessionId = 'sess789';
        
        // act
        Test.startTest();
        BotResponse res = new SupportStrategy().handle(req);
        Test.stopTest();
        
        // assert resposta do bot
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('Protocolo'), 'Deveria devolver o número de protocolo');
        
        // assert Case criado
        List<Case> cases = [
            SELECT Id, Subject 
            FROM Case 
            WHERE Origin = 'Chatbot'
        ];
        System.assertEquals(1, cases.size(), 'Um caso deveria ter sido criado');
        System.assert(cases[0].Subject.contains('Falha Login'), 'O assunto do caso deveria conter o tipo de falha');
        
        // assert log
        List<InteractionLog__c> logs = [
            SELECT Id, Status__c 
            FROM InteractionLog__c 
            WHERE Action__c = 'Support'
        ];
        System.assertEquals(1, logs.size(), 'Log de interação deveria ter sido salvo');
        System.assert(logs[0].Status__c.contains('Protocolo'), 'Status deveria registrar o protocolo');
    }
}
