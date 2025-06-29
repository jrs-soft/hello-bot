@isTest
private class TrackingStrategyTest {
    
    @isTest
    static void testTracking() {
        // arrange (simulação de dados)
        Contact contact = new Contact(LastName = 'Teste');
        insert contact;
        
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Rastreamento de Pedido',
            'orderId' => '123',
            'orderStatus' => 'InProgress'
        };
        req.sessionId = 'sessao-123';
        req.contactId = contact.Id;
        
        // act
        TrackingStrategy strategy = new TrackingStrategy();
        BotResponse response = strategy.handle(req);
        
        // assert
        System.assertNotEquals(null, response, 'A resposta não deveria ser nula.');
        System.assert(response.message.contains('caminho'), 'Deveria conter mensagem de rastreamento.');
        
        Integer count = [
            SELECT COUNT() FROM InteractionLog__c 
            WHERE Action__c = 'Tracking'
        ];
        System.assertEquals(1, count, 'Deveria ter salvo um log de rastreamento.');
    }
}
