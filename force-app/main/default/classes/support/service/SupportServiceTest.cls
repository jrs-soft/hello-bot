@isTest
private class SupportServiceTest {
    @isTest static void testCreateCase() {
        // setup
        String userId = '005XXXXXXXXXXXX';
        String issueType = 'Problema de Conexão';
        String description = 'O sistema está lento.';

        // exec
        SupportService service = new SupportService();
        String caseNumber = service.createCase(userId, issueType, description);

        // validate
        System.assertNotEquals(null, caseNumber, 'Protocolo deveria ser gerado');
        
        // consulta
        Case c = [SELECT Id, Subject, Description, Status FROM Case WHERE CaseNumber = :caseNumber LIMIT 1];
        System.assertEquals('New', c.Status);
        System.assert(c.Subject.contains(issueType), 'Subject deveria conter o issueType');
    }
}
