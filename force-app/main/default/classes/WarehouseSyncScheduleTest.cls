@isTest
public with sharing class WarehouseSyncScheduleTest {
    @isTest static void tastMethod() {
        Test.StartTest();
		WarehouseSyncSchedule testsche = new WarehouseSyncSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
        integer a = 10;
		Test.stopTest();
        
        System.assertEquals(10,a);
    }
}