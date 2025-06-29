@isTest
private class InteractionLoggerTest {
    
    @isTest
    static void testLogLongPayload() {
        // arrange
        String bigPayload = '';
        for (Integer i = 0; i < 5100; i++) {
            bigPayload += 'A';
        }
        
        // act
        Test.startTest();
        InteractionLogger.log(
            UserInfo.getUserId(),
            'TestAction',
            bigPayload,
            'OK'
        );
        Test.stopTest();
        
        // assert
        List<InteractionLog__c> logs = [
            SELECT Id, Payload__c 
            FROM InteractionLog__c
            WHERE Action__c = 'TestAction'
        ];
        System.assertEquals(1, logs.size(), 'Um log deveria ser inserido.');
        System.assert(
            logs[0].Payload__c.length() <= 5000, 
            'Payload deveria ter sido truncado no logger para no máximo 5000 caracteres.'
        );
    }
}
