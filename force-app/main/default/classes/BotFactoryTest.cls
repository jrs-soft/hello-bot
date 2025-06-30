@isTest
public class BotFactoryTest {
    
    @isTest
    static void testGetStrategy_Rastreamento() {
        // act
        BotStrategy strategy = BotFactory.getStrategy('Rastreamento de Pedido');
        
        // assert
        System.assertNotEquals(null, strategy, 'Estratégia de rastreamento não deveria ser nula');
        System.assert(strategy instanceof TrackingStrategy, 'Deveria ser TrackingStrategy');
    }
    
    @isTest
    static void testGetStrategy_SuporteTecnico() {
        BotStrategy strategy = BotFactory.getStrategy('Suporte Técnico');
        System.assertNotEquals(null, strategy);
        System.assert(strategy instanceof SupportStrategy, 'Deveria ser SupportStrategy');
    }
    
    @isTest
    static void testGetStrategy_PoliticaDevolucao() {
        BotStrategy strategy = BotFactory.getStrategy('Política de Devolução');
        System.assertNotEquals(null, strategy);
        System.assert(strategy instanceof ReturnPolicyStrategy, 'Deveria ser ReturnPolicyStrategy');
    }
    
    @isTest
    static void testGetStrategy_ContratacaoServico() {
        BotStrategy strategy = BotFactory.getStrategy('Contratação de Serviço');
        System.assertNotEquals(null, strategy);
        System.assert(strategy instanceof ServiceContractStrategy, 'Deveria ser ServiceContractStrategy');
    }
    
    @isTest
    static void testGetStrategy_ActionInvalida() {
        try {
            BotFactory.getStrategy('Ação inexistente');
            System.assert(false, 'Deveria lançar exceção para ação inválida');
        } catch (BotFactory.BotFactoryException ex) {
            System.assert(ex.getMessage().contains('Nenhuma estratégia'), 'Mensagem de exceção inesperada');
        }
    }
}
