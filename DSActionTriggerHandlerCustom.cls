/***************************************************
Anthony Kelly, Developer

Brief Description: DialSource trigger handler for the
DS Action object which calls a Queueable class to update
the disposition fields on the parent record.
****************************************************/
public class DSActionTriggerHandlerCustom
{   
    public static boolean updatesProcessed = False;

    public static void updateSObjects(List<DS_Denali__DialSource_Action__c> actionList, string kind)
    {
        /** 
        Create a Map hold custom object ID and  
        */
        Map<Id,String> records = new Map<Id,String>();
      
        //Build a list of recently dispositioned ID's
        for(DS_Denali__DialSource_Action__c  d : actionList)
        {
            //Check for DS's related calls
            /**
            Checks if one of the following conditions is true:
            - 1: Call disposition has a value and trigger context is update
            - 2: Subject is 'DialSource Automated Call'
            - 3: Subject is 'DialSource Inbound Call' and trigger context is 'insert'
             */
            if((!(String.isBlank(d.DS_Denali__Call_Disposition__c)) && 
                !(String.isBlank(d.DS_Denali__Call_Campaign__c)) && kind == 'update') || 
               ((d.DS_Denali__Subject__c  == 'DialSource Automated Call' ||  
                 d.DS_Denali__Subject__c  == 'DialSource Inbound Call') && kind == 'insert')) 
            {
                //Add using whatID
                /** 
                Ensure there is a value in Custom Object ID
                BUG FIX:    I also fixed a bug here where they weren't wrapping both statements below in curly brackets. After following it thru,
                            it technically didn't hurt anything but is sloppy code. If you don't use curly brackets with if/for/etc statements, then
                            only the first line after is included in the if, so here, the records.put line would have fired regardless of whether 
                            Custom Object ID was null. Now fixed.
                 */
                if(d.DS_Denali__Custom_Object_ID__c != NULL)
                {
                    /** 
                    Print Custom Object ID to debug
                     */
                    System.debug(d.DS_Denali__Custom_Object_ID__c);
                    
                
                    //replace custom_object__c with API name of custom object
                    
                    /** 
                    Add the custom object ID (key) and a concatenated string of [Disposition] + ':' " [Call Campaign] (value) to records Map 
                    */
                    records.put(d.DS_Denali__Custom_Object_ID__c, d.DS_Denali__Call_Disposition__c + ':' + d.DS_Denali__Call_Campaign__c );
                    //System.debug(d.DS_Denali__Custom_Object_ID__c, d.DS_Denali__Call_Disposition__c + ':' + d.DS_Denali__Call_Campaign__c );  
                }
            }
        
            //Create and call the queueable class to update the DS fields 
            /**
            Ensure that records has values - IE that at least one incoming record met at least one of the above conditions
            */
            if(records.size() > 0)
            {
                try{
                    /**
                    Create an instance of the DSUpdateFieldsCustom (queueable) class and queue the job
                    */
                    DSUpdateFieldsCustom updateDS = new DSUpdateFieldsCustom(records, kind);
                    ID jobID = System.enqueueJob(updateDS);
                }
                catch(exception e){

                    /**
                    If the job failed to queue, then send an error email to DialSource using the custom DialSource error email class.
                    */
                    DS_Denali.DSDenaliErrorEmail.sendError('DSActionTriggerHandlerCustom', e);
                } 

                /**
                If the context was 'update', mark that the updates happened
                 */
                if (kind == 'update')
                {
                    updatesProcessed = True; 
                }
            }
        }
    }}