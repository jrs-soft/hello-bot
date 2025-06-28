public class InteractionLogger {
    public static void log(
        String userId,
        String action,
        String payloadJson,
        String status
    ) {
        InteractionLog__c log = new InteractionLog__c();
        log.User__c = userId;
        log.Action__c = action;
        log.Payload__c = payloadJson;
        log.Timestamp__c = System.now();
        log.Status__c = status;

        insert log;

        System.debug('## Log salvo: ' + log);
    }
}
