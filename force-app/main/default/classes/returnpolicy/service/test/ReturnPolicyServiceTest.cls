@isTest
public class ReturnPolicyServiceTest {
    
    @isTest static void testGetPolicy() {
        ReturnPolicyService service = new ReturnPolicyService();
        String policy = service.getPolicy();
        System.assertNotEquals(null, policy, 'Política não deveria ser nula');
        System.assert(policy.contains('7 dias'), 'Deveria mencionar o prazo');
    }
    
    @isTest static void testCreateReturnRequest() {
        ReturnPolicyService service = new ReturnPolicyService();
        
        String protocol = service.createReturnRequest('12345', 'Produto com defeito', '005XXXXXXXXXXXX');
        System.assertNotEquals(null, protocol, 'Protocolo não deveria ser nulo');
        
        // valida ReturnRequest__c
        ReturnRequest__c r = [
            SELECT Id, OrderId__c, Reason__c, Status__c, Case__c
            FROM ReturnRequest__c
            WHERE Name = :protocol
            LIMIT 1
        ];
        System.assertEquals('Iniciado', r.Status__c);
        System.assertEquals('12345', r.OrderId__c);
        System.assertNotEquals(null, r.Case__c, 'Deveria estar relacionado a um Case');
        
        // valida Case vinculado
        Case c = [SELECT Id, Subject, Status FROM Case WHERE Id = :r.Case__c LIMIT 1];
        System.assertEquals('New', c.Status);
        System.assert(c.Subject.contains('Devolução'), 'Subject do Case deveria conter Devolução');
    }
}
