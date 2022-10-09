@IsTest
private class HP_TriggerHandlerContractTest {

    @TestSetup
    private static void setup() {
        Doctor__c newDoctor = new Doctor__c(First_Name__c = 'Jurek', Last_Name__c = 'Owsiak', License_Number__c = 'jS8wn2dwfs');
        Hospital__c newHospital = new Hospital__c(Name = 'Szpital pod wezwaniem JP2');
        insert newDoctor;
        insert newHospital;
    }

    @IsTest
    private static void shouldValidateContractForDateOverlappingWhenDateNotOverlapping() {
        Doctor__c newDoctor = [SELECT id FROM Doctor__c LIMIT 1];
        Hospital__c newHospital = [SELECT id FROM Hospital__c LIMIT 1];

        Contract__c newContract = new Contract__c(Start_Date__c = Date.parse('01/07/2022'), End_Date__c = Date.parse('09/07/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        Contract__c newContract2 = new Contract__c(Start_Date__c = Date.parse('11/07/2022'), End_Date__c = Date.parse('12/07/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        insert newContract;
        newContract = [SELECT id, Name, End_Date__c, Start_Date__c FROM Contract__c];

        String errorMsg = '';
        String errorMsgFromLabel = (String.format((Label.HP_Overlapping_Contract_Error_Message), new String[]{
                (newContract.Start_Date__c).format(), (newContract.End_Date__c).format(), newContract.Name
        }));

        Test.startTest();
        try {
            insert newContract2;
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        Test.stopTest();

        System.assert(!errorMsg.contains(errorMsgFromLabel), errorMsgFromLabel);

    }

    @IsTest
    private static void shouldValidateContractForDateOverlappingWhenDateNotOverlappingWithoutEndDate() {
        Doctor__c newDoctor = [SELECT id FROM Doctor__c LIMIT 1];
        Hospital__c newHospital = [SELECT id FROM Hospital__c LIMIT 1];

        Contract__c newContract = new Contract__c(Start_Date__c = Date.parse('01/07/2022'), Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        Contract__c newContract2 = new Contract__c(Start_Date__c = Date.parse('11/06/2022'), End_Date__c = Date.parse('12/06/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        insert newContract;
        newContract = [SELECT id, Name, End_Date__c, Start_Date__c FROM Contract__c];

        String errorMsg = '';
        String errorMsgFromLabel = (String.format((Label.HP_Overlapping_Contract_Error_Message), new String[]{
                (newContract.Start_Date__c).format(), '-', newContract.Name
        }));

        Test.startTest();
        try {
            insert newContract2;
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        Test.stopTest();

        System.assert(!errorMsg.contains(errorMsgFromLabel), errorMsgFromLabel);
    }

    @IsTest
    private static void shouldValidateContractForDateOverlappingWhenDateOverlapping() {
        Doctor__c newDoctor = [SELECT id FROM Doctor__c LIMIT 1];
        Hospital__c newHospital = [SELECT id FROM Hospital__c LIMIT 1];

        Contract__c newContract = new Contract__c(Start_Date__c = Date.parse('01/07/2022'), End_Date__c = Date.parse('30/07/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        Contract__c newContract2 = new Contract__c(Start_Date__c = Date.parse('11/06/2022'), End_Date__c = Date.parse('12/07/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        insert newContract;
        newContract = [SELECT id, Name, End_Date__c, Start_Date__c FROM Contract__c];

        String errorMsg;
        String errorMsgFromLabel = (String.format((Label.HP_Overlapping_Contract_Error_Message), new String[]{
                (newContract.Start_Date__c).format(), (newContract.End_Date__c).format(), newContract.Name
        }));

        Test.startTest();
        try {
            insert newContract2;
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        Test.stopTest();

        System.assert(!errorMsg.contains(errorMsgFromLabel), errorMsgFromLabel);
    }

    @IsTest
    private static void shouldValidateContractForDateOverlappingWhenDateOverlappingWithoutEndDate() {
        Doctor__c newDoctor = [SELECT id FROM Doctor__c LIMIT 1];
        Hospital__c newHospital = [SELECT id FROM Hospital__c LIMIT 1];

        Contract__c newContract = new Contract__c(Start_Date__c = Date.parse('01/07/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        Contract__c newContract2 = new Contract__c(Start_Date__c = Date.parse('11/07/2022'), End_Date__c = Date.parse('22/07/2022'),
                Doctor__c = newDoctor.id, Hospital__c = newHospital.id);

        insert newContract;
        newContract = [SELECT id, Name, End_Date__c, Start_Date__c FROM Contract__c];

        String errorMsg;
        String errorMsgFromLabel = (String.format((Label.HP_Overlapping_Contract_Error_Message), new String[]{
                (newContract.Start_Date__c).format(), '-', newContract.Name
        }));

        Test.startTest();
        try {
            insert newContract2;
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        Test.stopTest();

        System.assert(!errorMsg.contains(errorMsgFromLabel), errorMsgFromLabel);
    }
}