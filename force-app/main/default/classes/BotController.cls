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
        
        @InvocableVariable
        public String orderId; // <<< NOVO campo
    }
    
    @InvocableMethod(label='Process Bot Action')
    public static List<BotResponseWrapper> processBot(List<BotRequest> requests) {
        List<BotResponseWrapper> results = new List<BotResponseWrapper>();
        
        for (BotRequest req : requests) {
            BotStrategy strategy = BotFactory.getStrategy(req.action);
            
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('action', req.action);
            
            if (!String.isBlank(req.serviceName)) {
                parameters.put('serviceName', req.serviceName);
            }
            
            if (!String.isBlank(req.orderId)) {
                parameters.put('orderId', req.orderId);
            }
            
            BotRequestGlobal requestGlobal = new BotRequestGlobal();
            requestGlobal.parameters = parameters;
            requestGlobal.sessionId = req.sessionId;
            requestGlobal.contactId = req.contactId;
            
            BotResponse response = strategy.handle(requestGlobal);
            
            results.add(new BotResponseWrapper(response.message));
        }
        
        return results;
    }
}