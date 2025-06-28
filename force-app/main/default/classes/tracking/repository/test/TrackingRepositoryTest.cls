@IsTest
public class TrackingRepositoryTest {
    
    @IsTest
    static void testSaveTracking() {
        
        // dados simulados
        String orderId      = 'ORD9876';
        String userId       = 'USR987';
        String status       = 'Em Transporte';
        String deliveryDate = '2025-07-10';
        
        // executar o método
        TrackingRepository repo = new TrackingRepository();
        repo.saveTracking(orderId, userId, status, deliveryDate);
        
        // buscar no banco para validar
        List<OrderTracking__c> results = [
            SELECT Id, OrderId__c, UserId__c, Status__c, DeliveryDate__c
            FROM OrderTracking__c
            WHERE OrderId__c = :orderId
        ];
        
        System.assertEquals(1, results.size());
        System.assertEquals(orderId, results[0].OrderId__c);
        System.assertEquals(userId, results[0].UserId__c);
        System.assertEquals(status, results[0].Status__c);
        System.assertEquals(Date.valueOf(deliveryDate), results[0].DeliveryDate__c);
    }
}
