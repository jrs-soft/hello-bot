public with sharing class DefaultStrategy implements BotStrategy {
    public void handle(BotController.BotRequest req) {
        System.debug('Chamou DefaultStrategy');
    }
}
