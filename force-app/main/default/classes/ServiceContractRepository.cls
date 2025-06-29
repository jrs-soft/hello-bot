public class ServiceContractRepository {
    public static Service__c getServiceByName(String name) {
        List<Service__c> results = [
            SELECT Id, Name, BasePrice__c 
            FROM Service__c 
            WHERE Name = :name 
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
}
