public class BotRequest {
    @InvocableVariable(required=true)
    public String action;
    
    @InvocableVariable
    public String sessionId;
    
    @InvocableVariable
    public String contactId;
    
    @InvocableVariable
    public String serviceName;
    
    @InvocableVariable
    public String orderId;
    
    @InvocableVariable
    public String description;
    
    @InvocableVariable
    public String issueType;
}