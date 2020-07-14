/***************************************************
Edgar Perez, Developer

Updated 8/1/2017 by Jitesh Bhatia
Updated to collect Tasks into different list depending
on whether the Call Campaign or the Call Disposition
is updated.

Updated 8/8/2017 by Jitesh Bhatia
Updated to collect Tasks into a single list, but adjusted to 
make sure this happens only when both the Call Campaign and 
Call Disposition are populated on the Task.

Last Updated 8/17/2017 by Jitesh Bhatia
Updated to prevent the trigger from firing multiple times.

Brief Description: DialSource trigger on the Task object 
that collects all the DialSource related Tasks.
****************************************************/
trigger DSActionTriggerCustom on DS_Denali__DialSource_Action__c  (after insert, after update, before update) 
{
    if(trigger.isInsert)
    {    
        /**
        For before and after insert contexts, pass incoming DSAs to handler along with a string denoting the 'insert' trigger context
        */
        DSActionTriggerHandlerCustom.updateSObjects((List<DS_Denali__DialSource_Action__c>)trigger.new, 'insert');
    }
    
    /**
    This looks like the part we were working on, ya? Assuming b/c the non-namespaced field
     */
    if(trigger.isBefore){
        //List<DS_Denali__DialSource_Action__c> beforeActions = new List<DS_Denali__DialSource_Action__c>();
        for(DS_Denali__DialSource_Action__c a : trigger.new){
            a.Custom_Object__c = a.DS_Denali__Custom_Object_ID__c;
            //beforeActions.add(a);
        }
    }
    
    /**
    Check to make sure the trigger handler has not already updated the parent record fields in the .isInsert context
     */
    if (!DSActionTriggerHandlerCustom.updatesProcessed)
    {
        /**
        Ensure trigger is in the update context - either before/after update
         */
        if(trigger.isUpdate)
        {
            //List to keep track of the DSAs
            List<DS_Denali__DialSource_Action__c> actions = new List<DS_Denali__DialSource_Action__c>();
            
            /**
            Loop thru incoming DSAs
             */
            for(DS_Denali__DialSource_Action__c a : trigger.new)
            {
                //get ID of action before update
                /**
                Dunno what that other comments means.
                Instantiate the old DSA record 
                NOTE: oldMap contains a list of the values on the DSA before the update was executed. In .isInsert contexts, oldMap is null
                 */
                DS_Denali__DialSource_Action__c oldAction = Trigger.oldMap.get(a.id);
                
                
                //Call Disposition Updated or Call Campaign Updated
                /**
                Check that one of the following conditions is true
                1: Basically Disposition (ISCHANGED) AND Campaign isn't null
                2: Basically Campaign (ISCHANGED) AND Disposition isn't null
                 */
                if((!String.isBlank(a.DS_Denali__Call_Disposition__c) && String.isBlank(oldAction.DS_Denali__Call_Disposition__c) 
                    && !String.isBlank(a.DS_Denali__Call_Campaign__c)) ||(!String.isBlank(a.DS_Denali__Call_Campaign__c) && 
                     String.isBlank(oldAction.DS_Denali__Call_Campaign__c) && !String.isBlank(a.DS_Denali__Call_Disposition__c)))
                    
                    /**
                    Add actions meeting criteria to a List
                     */
                    actions.add(a);
            }
            
            /**
            If there are actions that met the criteria, queue them for processing with the 'update' context as a param
             */
            if (!actions.isEmpty())
                DSActionTriggerHandlerCustom.updateSObjects(actions, 'update');
        }
         
    }
}