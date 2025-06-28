@IsTest
public class TrackingServiceTest {
    
    @IsTest
    static void testTrackOrderSuccess() {
        
        Test.setMock(HttpCalloutMock.class, new TrackingApiMock());
        
        // preparar dados (opcional se quiser um contexto)
        String fakeOrderId = 'ORD1234';
        String fakeUserId  = 'USR123';
        
        // executar
        TrackingService service = new TrackingService();
        TrackingResult result = service.trackOrder(fakeOrderId, fakeUserId);
        
        // verificar resultado
        System.assertEquals('Entregue', result.status);
        System.assertEquals('2025-07-01', result.deliveryDate);
        
        // verificar se persistiu (OrderTracking__c)
        List<OrderTracking__c> records = [SELECT Id, OrderId__c, Status__c, DeliveryDate__c 
                                          FROM OrderTracking__c 
                                          WHERE OrderId__c = :fakeOrderId];
        System.assertEquals(1, records.size());
        System.assertEquals('Entregue', records[0].Status__c);
    }
    
    @IsTest
    static void testTrackOrderApiError() {
        
        Test.setMock(HttpCalloutMock.class, new TrackingApiMockError());
        
        String fakeOrderId = 'ORD5678';
        String fakeUserId  = 'USR567';
        
        TrackingService service = new TrackingService();
        
        try {
            service.trackOrder(fakeOrderId, fakeUserId);
            System.assert(false, 'Deveria ter lançado TrackingException');
        } catch (TrackingService.TrackingException ex) {
            System.assert(ex.getMessage().contains('Erro ao consultar pedido'));
        }
    }
}
