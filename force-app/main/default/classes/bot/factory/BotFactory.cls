public with sharing class BotFactory {
    public static BotStrategy getStrategy(String action) {
        switch on action {
            when 'Rastreamento de Pedido' {
                return new TrackingStrategy();
            }
            when 'Suporte Técnico' {
                return new SupportStrategy();
            }
            when 'Política de Devolução' {
                return new ReturnPolicyStrategy();
            }
            when 'Contratação de Serviço' {
                return new ServiceContractStrategy();
            }
            when else {
                return new DefaultStrategy();
            }
        }
    }
}
