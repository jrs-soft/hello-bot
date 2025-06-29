public class InteractionLogger {
    public static void log(
        String userId,
    String action,
    String payloadJson,
    String status
    ) {
        try {
            InteractionLog__c log = new InteractionLog__c();
            log.User__c = userId;
            log.Action__c = action;
            if(payloadJson != null && payloadJson.length() > 5000){
                payloadJson = payloadJson.substring(0,5000);
            }
            log.Payload__c = payloadJson;
            log.Timestamp__c = System.now();
            log.Status__c = status;
            
            Database.insert(log, false);
            System.debug('## Log salvo: ' + log);
        } catch(Exception e) {
            System.debug('## Falha ao salvar log: ' + e.getMessage());
        }
    }
}