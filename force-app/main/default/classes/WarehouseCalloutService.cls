public with sharing class WarehouseCalloutService {
    

    public static void getResponse(){
        Map<Id , Object> productMap = new Map<Id , Object>();
        List<Object> listEquipment = new List<Object>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.95326042.714024356.1679297006-539882339.1671765279');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            // System.debug(JSON.deserializeUntyped(response.getBody()));
            // Map<String , Object> responseMap = new Map<String, Object>(JSON.deserializeUntyped(response.getBody()));
            listEquipment  = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(listEquipment);
        }
        // convertListToMap(listEquipment,productMap);
        System.debug(listEquipment);
        // System.debug(listEquipment[0].get((String)));
    }
    // public static void convertListToMap(List<Object> objectList,Map<Id , Object> productMap){
    //     for(Object obj : objectList){
    //         productMap.put((Id) obj[].get('_id'),obj);
    //     }
    // }
}
