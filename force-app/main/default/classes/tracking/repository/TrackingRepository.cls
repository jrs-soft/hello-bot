public class TrackingRepository {
    
    public void saveTracking(String orderId, String userId, String status, String deliveryDate) {
        
        OrderTracking__c record = new OrderTracking__c();
        record.OrderId__c = orderId;
        record.UserId__c = userId;
        record.Status__c = status;
        if (deliveryDate != null) {
            record.DeliveryDate__c = Date.valueOf(deliveryDate);
        }
        insert record;
    }
}
