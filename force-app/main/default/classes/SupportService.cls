public class SupportService {
    public String createCase(String userId, String issueType, String description) {
        Case c = new Case(
            Subject = 'Suporte Bot - ' + issueType,
            Description = description,
            Origin = 'Chatbot',
            Status = 'New'
        );
        insert c;
        // forçar consulta para CaseNumber
        c = [SELECT CaseNumber FROM Case WHERE Id = :c.Id];
        return c.CaseNumber;
    }
}
