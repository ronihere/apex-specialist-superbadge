trigger MaintenanceRequest on Case (before update) {
    // System.debug(trigger.newMap);
    System.debug('in the trigger');
    MaintainanceRequestHelper.methodCreateRecord(trigger.NewMap);
}