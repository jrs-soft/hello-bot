@isTest
public class TrackingStrategyTest {
    
    @isTest
    static void testPedidoEmBranco() {
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Rastreamento de Pedido'
                // sem orderId
        };
        req.sessionId = 'sess-123';
        req.contactId = '003XXXXXXXXXXXXXXX';
        
        TrackingStrategy strategy = new TrackingStrategy();
        BotResponse res = strategy.handle(req);
        
        System.assertNotEquals(null, res);
        System.assert(res.message.contains('informe o número do pedido'));
    }
    
    @isTest
    static void testPedidoNaoEncontrado() {
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Rastreamento de Pedido',
            'orderId' => '999'
        };
        req.sessionId = 'sess-999';
        req.contactId = '003XXXXXXXXXXXXXXX';
        
        TrackingStrategy strategy = new TrackingStrategy();
        BotResponse res = strategy.handle(req);
        
        System.assertNotEquals(null, res);
        System.assert(
            res.message.contains('não encontrado') ||
            res.message.toLowerCase().contains('desculpe'),
        'Deveria informar falha de rastreamento.'
            );
    }
    
    @isTest
    static void testErroTrackingService() {
        // para forçar erro, podemos passar algo mal formado
        BotRequestGlobal req = new BotRequestGlobal();
        req.parameters = new Map<String, Object>{
            'action' => 'Rastreamento de Pedido',
            'orderId' => '!!'
        };
        req.sessionId = 'sess-erro';
        req.contactId = '003XXXXXXXXXXXXXXX';
        
        TrackingStrategy strategy = new TrackingStrategy();
        BotResponse res = strategy.handle(req);
        
        System.assertNotEquals(null, res);
        System.assert(
            res.message.toLowerCase().contains('desculpe') ||
            res.message.toLowerCase().contains('não encontrado'),
        'Deveria exibir mensagem de falha ou pedido não encontrado.'
            );
    }
}