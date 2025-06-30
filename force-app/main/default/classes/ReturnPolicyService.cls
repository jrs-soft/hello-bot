public class ReturnPolicyService {
    
    public String getPolicy() {
        return 'A política de devolução prevê que produtos podem ser devolvidos em até 7 dias após o recebimento, desde que não utilizados.';
    }
    
    public String createReturnRequest(String orderId, String reason, String userId) {
        if (String.isBlank(orderId)) {
            throw new ReturnPolicyException('O campo OrderId não pode ser vazio.');
        }
        
        try {
            Case c = new Case(
                Subject = 'Devolução - ' + orderId,
                Description = reason,
                Status = 'New',
                Origin = 'Chatbot'
                );
            insert c;
            System.debug('CASE inserido: ' + c.Id);
            
            ReturnRequest__c r = new ReturnRequest__c(
                OrderId__c = orderId,
                Reason__c = reason,
                Status__c = 'Iniciado',
                UserId__c = userId,
                Case__c = c.Id
                );
            insert r;
            System.debug('RETURNREQUEST inserido: ' + r.Id);
            
            // recarrega Name gerado
            r = [SELECT Name FROM ReturnRequest__c WHERE Id = :r.Id];
            
            return r.Name;
        } catch (Exception e) {
            System.debug('Erro ao criar solicitação de devolução: ' + e.getMessage());
            throw e;
        }
    }
}