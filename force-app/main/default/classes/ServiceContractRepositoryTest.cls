@isTest
public class ServiceContractRepositoryTest {
    
    @isTest
    static void testGetServiceByName_Found() {
        // arrange
        Service__c svc = new Service__c(
            Name = 'Consultoria',
            BasePrice__c = 500
        );
        insert svc;
        
        // act
        Service__c result = ServiceContractRepository.getServiceByName('Consultoria');
        
        // assert
        System.assertNotEquals(null, result, 'Deveria retornar um serviço');
        System.assertEquals(svc.Id, result.Id, 'O ID do serviço deveria ser o mesmo');
        System.assertEquals(500, result.BasePrice__c, 'O preço base deveria ser 500');
    }
    
    @isTest
    static void testGetServiceByName_NotFound() {
        // arrange
        // nada a inserir
        
        // act
        Service__c result = ServiceContractRepository.getServiceByName('Inexistente');
        
        // assert
        System.assertEquals(null, result, 'Deveria retornar null para serviço não encontrado');
    }
}
