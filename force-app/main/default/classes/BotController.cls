public with sharing class BotController {
    
    @InvocableMethod(label='Process Bot Action')
    public static void processBot(List<BotRequest> requests) {
        for (BotRequest req : requests) {
            // Factory delega para a estratégia correta
            BotStrategy strategy = BotFactory.getStrategy(req.action);
            strategy.handle(req);
        }
    }
    
    public class BotRequest {
        @InvocableVariable(required=true)
        public String userId;
        
        @InvocableVariable(required=true)
        public String action;
        
        @InvocableVariable
        public String payloadJson;
    }
}
