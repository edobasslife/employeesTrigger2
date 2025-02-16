trigger updateEmployees on Contact (after insert, after update, after delete) {
    ContactTriggerHandler.updateEmployeeCount(
        Trigger.new, 
        Trigger.oldMap, 
        Trigger.isAfter, 
        Trigger.isInsert, 
        Trigger.isUpdate, 
        Trigger.isDelete
    );
}