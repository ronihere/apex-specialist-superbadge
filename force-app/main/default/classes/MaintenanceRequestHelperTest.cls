@isTest
public with sharing class MaintenanceRequestHelperTest {
    @isTest static void demoName(){
        Vehicle__c vehicleTest = new Vehicle__c(Name='Test Vehicle');
        insert vehicleTest;

        Product2 equipmentTest = new Product2(Maintenance_Cycle__c=30,Name='Test Eqipment',
        Lifespan_Months__c=12,
        Replacement_Part__c =true);
        insert equipmentTest;


        
        Case maintenanceRequestTest = new Case(Status='new',Vehicle__c=vehicleTest.Id,Subject='Test maintenance request',ProductId=equipmentTest.Id,Type='Repair');
        insert maintenanceRequestTest;


        Equipment_Maintenance_Item__c equipmentMaintenanceItemTest = new Equipment_Maintenance_Item__c(Equipment__c = equipmentTest.Id ,Maintenance_Request__c=maintenanceRequestTest.Id
        );
        insert equipmentMaintenanceItemTest;


        Test.startTest();
        
        maintenanceRequestTest.Status='Closed';
        upsert maintenanceRequestTest;
        
        Test.stopTest();
		
        List<Case> autoCreatedCase =[SELECT Id,(SELECT Id , Name FROM Equipment_Maintenance_Items__r) FROM Case WHERE Vehicle__c=:vehicleTest.Id AND Id !=:maintenanceRequestTest.Id]; //---> fetches the Trigger autocreated routine maintenance case

        

        System.assertEquals(autoCreatedCase.size() , 1);//  ---> if the autocreatedcase query was done with vehicleId , then this assertequals would have came to picture 
        // System.assertEquals(autocreatedC)
        //System.assertEquals(expected, actual);
    }
}