public class HP_TriggerHandlerContract {

    public void validateContract(List<Contract__c> newContracts) {

        List<Contract__c> contracts = [SELECT Name, Doctor__c, Hospital__c, Start_Date__c, End_Date__c from Contract__c];

        for (Contract__c newContract : newContracts) {
            for (Contract__c contract : contracts) {
                if (contract.Doctor__c == newContract.Doctor__c && contract.Hospital__c == newContract.Hospital__c) {
                    if ((contract.End_Date__c == null) && (contract.Start_Date__c < newContract.End_Date__c || newContract.End_Date__c == null)
                    ) {
                        newContract.addError(String.format(Label.HP_Overlapping_Contract_Error_Message, new String[]{
                                (contract.Start_Date__c).format(), '-', contract.Name
                        }));
                    } else if (newContract.End_Date__c >= contract.Start_Date__c && contract.End_Date__c >= newContract.Start_Date__c) {
                        newContract.addError(String.format(Label.HP_Overlapping_Contract_Error_Message, new String[]{
                                (contract.Start_Date__c).format(), (contract.End_Date__c).format(), contract.Name
                        }));
                    }
                }
            }
        }
    }
}