/***************************************************
Anthony Kelly, Developer

Brief Description: Queueable class that updates the 
disposition fields on the DS Action's parent record.
****************************************************/
public class DSUpdateFieldsCustom implements Queueable
{
    /**
    Delcare variables for use within the execute() method
     */
    private Map<Id,String> records;
    List<List<sObject>> objects = new List<List<sObject>>();
    string kind;
    
    /**
    Constructor - takes the incoming parameters and maps them to the local class variables declared above
     */
    public DSUpdateFieldsCustom(Map<Id,String> records, string kind)
    {
        this.records = records;
        this.kind = kind; 
    }
    
    /**
    Required method containing the logic for this queueable class
     */
    public void execute(QueueableContext context)
    {
        /**
        Variables to track how many queries have been performed within this job, and whether the job should still be performing queries
         */
        Boolean performQuery = True;
        Integer queriesPerformed = 0;

        //Query for the parent records.
        /**
        If unsuccessful, retry the query until the maximum allowed queries has been reached -
        This will be denoted by performQuery being marked false
         */
        while (performQuery)
        {
          try{
              /**
              Query for DS-related fields on the custom object that is the parent of one of the DSAs was logged on
              Add any recoreds found to a generic SObject List
              NOTE: This query returns a List of Lists of generic SObjects - likely one list for each custom object in your database
               */
              this.objects.add([SELECT Id, Datetime_of_Last_Disposition__c, Last_Disposition__c, Total_Call_Count__c 
                FROM Custom_Object__c WHERE Id IN: records.keySet() FOR UPDATE]);
              /**
              If the query was successful and returned records, then mark the performQuery flag to false to prevent further queries
               */
              performQuery = False;
          }
          catch(exception e){ 
            /**
            Check if the query failed due to a record lock error
            Check whether the number of queries performed within this job is less than 3
             */
            if (e.getMessage().contains('Record Currently Unavailable') && queriesPerformed < 3)
            {
              /**
              If above conditions are met, mark the job to perform another query and increment the query counter by 1
               */
              performQuery = True;
              queriesPerformed++;
              System.debug('Lock row error');
            }
            /**
            If the error was anything else or 3+ queries have been performed, mark the class to stop performing queries and send an error email
             */
            else
            {
              performQuery = False;
              DS_Denali.DSDenaliErrorEmail.sendError('DSUpdateFieldsCustom', e);
            }
          }
        }
        
        //On update, update the Last Disposition, Datetime
        //of Last Disposition, and Last Call Campaign, Call Count
        if(kind == 'update')
        {
          //Iterate through the objects and update the fields
          System.debug('objects: ' + objects);
          
            /**
            Iterate through each list of each type of custom object retrieved
             */
            for(List<sObject> l : objects)
            {
              /**
              Most of these lists are likely null since we probably only call against one custom object type in Denali, and therefore likely
              only had one type of custom obj ID in our query list.
               */
              for(sObject o : l)
              {
               /**
               Check for null objects
               Update the fields using the SObject 'put' method, which allows you to update fields that you know the API name of, even if you
               do not know the Object's API name.
                */
               if(o != null)
               {
                   //Update the Last Disposition 
                   o.put('Last_Disposition__c', records.get(o.id).substringbefore(':'));

                   //Update the Last Call Campaign
                   o.put('Last_Call_Campaign_Name__c', records.get(o.id).substringafter(':'));
                       
                   //Update the Datetime of Last Disposition
                   o.put('Datetime_of_Last_Disposition__c', DateTime.now());

                   //Increase the Total Call Count by 1
                   if(o.get('Total_Call_Count__c') == null){
                       o.put('Total_Call_Count__c', 1);
                    }
                   else {
                      o.put('Total_Call_Count__c', (Decimal)o.get('Total_Call_Count__c') + 1);
                    }                    
                }
               }
                  

            try{
                update l;
            }
            catch(exception e){
                DS_Denali.DSDenaliErrorEmail.sendError('DSUpdateFieldsCustom', e);
            }            
          }
        }
    }
}