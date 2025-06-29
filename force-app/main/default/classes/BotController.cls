public with sharing class BotController {
    
    public class BotRequest {
        @InvocableVariable(required=true)
        public String action;
        
        @InvocableVariable
        public String sessionId;
        
        @InvocableVariable
        public String contactId;
        
        @InvocableVariable
        public String serviceName; // opcional
    }
    
    @InvocableMethod(label='Process Bot Action')
    public static void processBot(List<BotRequest> requests) {
        for (BotRequest req : requests) {
            BotStrategy strategy = BotFactory.getStrategy(req.action);
            
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('action', req.action);
            
            if (!String.isBlank(req.serviceName)) {
                parameters.put('serviceName', req.serviceName);
            }
            
            BotRequestGlobal requestGlobal = new BotRequestGlobal();
            requestGlobal.parameters = parameters;
            requestGlobal.sessionId = req.sessionId;
            requestGlobal.contactId = req.contactId;
            
            BotResponse response = strategy.handle(requestGlobal);
            System.debug('## Bot response: ' + response.message);
        }
    }
}
