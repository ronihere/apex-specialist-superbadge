public with sharing class WarehouseCalloutService implements Queueable , Database.AllowsCallouts {
    
    public void execute(QueueableContext context){
        
            Map<Id , Object> productMap = new Map<Id , Object>();
            List<Object> listEquipment = new List<Object>();
            List<RestResponseWrapper> serializedResponse = new List<RestResponseWrapper>();

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.95326042.714024356.1679297006-539882339.1671765279');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                
                serializedResponse = RestResponseWrapper.parse(response.getBody());
                
            }
            if(serializedResponse.size()>0){
                updateData(serializedResponse);
            }
    }
    public static void updateData(List<RestResponseWrapper> arrList){
        List<Product2> upsertProduct2List = new List<Product2>();
        for(RestResponseWrapper j : arrList){
            Product2 p = new Product2();
            p.Warehouse_SKU__c = (String)j.sku;
            p.Name = j.name;
            p.Cost__c = j.cost;
            p.Replacement_Part__c = true;
            p.Lifespan_Months__c = j.lifespan;
            p.Maintenance_Cycle__c = j.maintenanceperiod;
            
            upsertProduct2List.add(p);
        }
        
        upsert upsertProduct2List;
        System.debug(upsertProduct2List);
    }
    
}