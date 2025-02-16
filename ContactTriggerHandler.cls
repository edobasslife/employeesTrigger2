public class ContactTriggerHandler {
    
    public static void updateEmployeeCount(
        List<Contact> newContacts,
        Map<Id, Contact> oldContactsMap,
        Boolean isAfter,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isDelete
    ) {
        Set<Id> accIds = new Set<Id>();
        
        if (isAfter) {
            if (isInsert) {
                for (Contact con : newContacts) {
                    if (con.AccountId != null) {
                        accIds.add(con.AccountId);
                    }
                }
            }
            
            if (isUpdate) {
                for (Contact con : newContacts) {
                    Contact oldCon = oldContactsMap.get(con.Id);
                    // Always add the new AccountId (if not null)
                    if (con.AccountId != null) {
                        accIds.add(con.AccountId);
                    }
                    // Add the old AccountId (if not null and different from the new one)
                    if (oldCon.AccountId != null && oldCon.AccountId != con.AccountId) {
                        accIds.add(oldCon.AccountId);
                    }
                }
            }
            
            if (isDelete) {
                for (Contact con : oldContactsMap.values()) {
                    if (con.AccountId != null) {
                        accIds.add(con.AccountId);
                    }
                }
            }
        }
        
        if (!accIds.isEmpty()) {
            List<Account> acctList = [
                SELECT Id, NumberOfEmployees__c, (SELECT Id FROM Contacts) 
                FROM Account 
                WHERE Id IN :accIds
            ];
            
            List<Account> accountsToUpdate = new List<Account>();
            
            for (Account acc : acctList) {
                acc.NumberOfEmployees__c = acc.Contacts.size();
                accountsToUpdate.add(acc);
            }
            
            if (!accountsToUpdate.isEmpty()) {
                try {
                    update accountsToUpdate;
                } catch (DmlException e) {
                    System.debug('An error has occurred: ' + e.getMessage());
                }
            }
        }
    }
}