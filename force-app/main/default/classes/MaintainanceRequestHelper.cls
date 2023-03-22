public with sharing class MaintainanceRequestHelper {




    public  static void methodCreateRecord(Map<Id , Case> mapp) {
            List<Case> listToBeInserted = new List<Case>();
            List<List<Id>> listOfList = new List<List<Id>>();
            Map<Id , Decimal> reqToCycleMap = new Map<Id , Decimal>();
            List<String> caseIdList = new List<String>();

            for(Id key : mapp.Keyset()){
                Case obj = mapp.get(key);
                if(obj.Type == 'Repair' || obj.Type== 'Routine Maintenance'){
                    if(obj.Status=='closed'){
        
                        caseIdList.add(obj.Id);
                    }
                }

            }
             Map<Id ,Case> caseMap = new Map<Id,Case>([SELECT Id, Vehicle__c, Type , Product__c , Status, (SELECT Equipment__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Id IN :caseIdList]);



            mapRequestIdToMinCycleDay(caseIdList, caseMap); // return the map where key(maintainance_request__c)  ---> value(min_cycleDay from its all relatedlist)
            System.debug(caseMap);
            for(Id key : caseMap.keySet()){
                Case obj = caseMap.get(key);
                        Case newCase = new Case();
                        newCase.ParentId = key;
                        newCase.Status = 'New';
                        newCase.Subject = 'Routine Maintenance';
                        newCase.Type = 'Routine Maintenance';
                        newCase.Vehicle__c=obj.Vehicle__c;
                        newCase.Product__c=obj.Product__c;
                        newCase.Date_Reported__c = Date.Today();
                        newCase.Date_Due__c = obj.Date_Due__c;
                        
                        
                        List<Id> eqpmnt = new List<Id>();
                      
                        for(Integer i=0;i<obj.Equipment_Maintenance_Items__r.size();i++){
                            eqpmnt.add((Id)obj.Equipment_Maintenance_Items__r[i].get('Equipment__c'));
                            
                        }
                        listOfList.add(eqpmnt);
                        
                listToBeInserted.add(newCase);
            }
            
            insert listToBeInserted;
            callMethod(listOfList,listToBeInserted);
            
        }

        public static void callMethod(List<List<Id>> listOfList ,List<Case> listToBeInserted){
            List<Equipment_Maintenance_Item__c> listInsert = new List<Equipment_Maintenance_Item__c>();
            Integer count=0;
            for(Integer i=0;i<listOfList.size();i++){
                
                for(Integer j=0;j<listOfList.get(i).size();j++){
                    Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c();
                        item.Equipment__c = listOfList.get(i).get(j);
                        item.Maintenance_Request__c = listToBeInserted.get(i).Id;
                        listInsert.add(item);
                }
                
            }
          
            insert listInsert;
            System.debug(listInsert);



        }

        public static void addMinCycleDayToCaseMapObjects(Map<Id , Case> caseMap,Map<Id,Decimal> reqToCycleMap){
            for(Id item : caseMap.keySet()){
                caseMap.get(item).Date_Due__c = Date.today().addDays((Integer)reqToCycleMap.get(item));
            }
            return;
        }



        public static void mapRequestIdToMinCycleDay(List<Id> caseIdList, Map<Id,Case> caseMap){
            Map<Id , Decimal> reqToCycleMap = new Map<Id , Decimal>();
            List<SObject> minCycleDayList = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)cycle FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :caseIdList GROUP BY Maintenance_Request__c];
            for(SObject obj : minCycleDayList){
                Decimal days = (Decimal)obj.get('cycle');
                caseMap.get((Id)obj.get('Maintenance_Request__c')).Date_Due__c = Date.Today().addDays((Integer)days);
            }
        }
}