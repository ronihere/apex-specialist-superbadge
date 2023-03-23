global class demo implements Schedulable {
   
    global void execute(SchedulableContext ctx) {
        // WarehouseCalloutService w = new WarehouseCalloutService();
        System.enqueueJob(new WarehouseCalloutService());
      
    }

}