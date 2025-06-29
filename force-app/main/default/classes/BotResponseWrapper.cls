public class BotResponseWrapper {
    @InvocableVariable(label='Response Message')
    public String responseMessage;
    
    public BotResponseWrapper(String message) {
        this.responseMessage = message;
    }
}