@isTest
public class ServiceContractServiceTest {
    
    @isTest
    static void testGenerateQuote_Success() {
        // arrange
        Account acc = new Account(Name = 'Cliente Teste');
        insert acc;
        
        Contact contact = new Contact(LastName = 'Fulano', AccountId = acc.Id);
        insert contact;
        
        Service__c svc = new Service__c(
            Name = 'Instalação de Software',
            BasePrice__c = 350
        );
        insert svc;
        
        // act
        Test.startTest();
        Quote__c quote = ServiceContractService.generateQuote('Instalação de Software', contact.Id);
        Test.stopTest();
        
        // assert
        System.assertNotEquals(null, quote, 'Deveria retornar um orçamento');
        System.assertEquals(contact.Id, quote.Customer__c, 'O cliente deveria ser o mesmo');
        System.assertEquals(svc.Id, quote.Service__c, 'O serviço deveria ser vinculado');
        System.assertEquals(350, quote.Price__c, 'O preço deveria ser 350');
        System.assertEquals('Pending', quote.Status__c, 'Status deveria ser Pending');
    }
    
    @isTest
    static void testGenerateQuote_ServiceNotFound() {
        // arrange
        Account acc = new Account(Name = 'Cliente Teste 2');
        insert acc;
        
        Contact contact = new Contact(LastName = 'Beltrano', AccountId = acc.Id);
        insert contact;
        
        // act + assert
        Test.startTest();
        try {
            ServiceContractService.generateQuote('Serviço Inexistente', contact.Id);
            System.assert(false, 'Deveria ter lançado exceção para serviço não encontrado');
        } catch (ServiceContractException ex) {
            System.assert(ex.getMessage().contains('Serviço não encontrado'), 'Mensagem da exceção incorreta');
        }
        Test.stopTest();
    }
}
