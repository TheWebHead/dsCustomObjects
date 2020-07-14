@isTest
public class DSActionTriggerTest {

 @isTest(seealldata = true)
 static void insertCustomObject() {

  //Search the database for the active user and grab the first user id

  List < User > activeUserList = new List < User > ([SELECT Id FROM User WHERE IsActive = true]);
  List < Id > activeUserIdList = new List < Id > ();
  
  DS_Denali__DialSource_Sessions_V3__c dsSesh = new DS_Denali__DialSource_Sessions_V3__c();
  dsSesh.Name = '0624b32b-f68d-44bb-9449-b052a916a084 - 5de6f7b01d8f45000b366596';
  insert dsSesh;

  Id dsSeshId = dsSesh.Id;
     
     
  for (User u: activeUserList) {
   activeUserIdList.add(u.Id);
  }

  Id UID = activeUserIdList[0];

  //UNCOMMENT NEXT LINE IF RECORD TYPE MATTERS

  //Id DSCustomObject_Type = Schema.SObjectType.Custom_Object_API_Name__c.getRecordTypeInfosByName().get('Record_Type_Name').getRecordTypeId();

/*Instantiate a new custom object
Replace both instances of DSCustom_Object__c with the API name of the Custom Object*/

  Custom_Object__c DSCustomObj = new Custom_Object__c(
   
   //UNCOMMENT NEXT LINE IF RECORD TYPE MATTERS

   //RecordTypeId = ContactRecordType,

/*
   Create a record using ~at least~ the fields that are required to insert an instance of the object
   Make sure to add __c to any field names that are custom to the object
*/
   //replace these with the required fields needed to
   //insert the custom object
   Name = 'DialSource',
   Phone__c     = '555-555-5555',
   
   //leave these alone
   Total_Call_Count__c = null,
   Last_Disposition__c = null,
   Last_Call_Campaign_Name__c = null,
   Datetime_of_Last_Disposition__c = null
  );


  System.debug('This is a new ' + DSCustomObj);
  insert DSCustomObj;
  System.debug('Inserted ' + DSCustomObj + ' 1');
  Map<Id, String> myCustomObjects = new Map<Id, String>();
  myCustomObjects.put(DSCustomObj.Id, 'first entry');
  System.debug('Use this map: ' + myCustomObjects);
     
  //leave this alone
  DS_Denali__DialSource_Action__c t2 = new DS_Denali__DialSource_Action__c(
   DS_Denali__Owner__c = UID,
   DS_Denali__Custom_Object_ID__c = DSCustomObj.Id,
   DS_Denali__Call_Disposition__c = 'DialSource Automated Call',
   DS_Denali__Call_Campaign__c = 'Test List 2!',
   DS_Denali__DialSource_Session__c = dsSeshId,
   DS_Denali__Call_Ended__c = System.now()
  );

  
  Test.startTest();
  insert t2;
  t2.DS_Denali__Subject__c = 'In Progress';
  t2.DS_Denali__Call_Disposition__c = 'Recycle';
  update t2;
      
  
  Test.stopTest();
  
  //System.assertEquals(1, DSCustomObj.Total_Call_Count__c);
 }

 @isTest(seealldata = true)
 static void updateTask() {

  /*
  Id AppRecordType = Schema.SObjectType.TargetX_SRMb__Application__c.getRecordTypeInfosByName().get('ESL CRM Application').getRecordTypeId();
  Id ContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Colleague Control Student').getRecordTypeId();
  */

  //Search the database for the active user and grab the first user id
  List < User > activeUserList = new List < User > ([SELECT Id FROM User WHERE IsActive = true]);
  List < Id > activeUserIdList = new List < Id > ();

  for (User u: activeUserList) {
   activeUserIdList.add(u.Id);
  }
  Id UID = activeUserIdList[0];

  //UNCOMMENT NEXT LINE IF RECORD TYPE MATTERS

  //Id DSCustomObject_Type = Schema.SObjectType.Custom_Object_API_Name__c.getRecordTypeInfosByName().get('Record_Type_Name').getRecordTypeId();

  /*
  Instantiate a new custom object
  Replace both instances of DSCustom_Object__c with the API name of the Custom Object
  */

    Custom_Object__c DSCustomObj = new Custom_Object__c(
   
   //UNCOMMENT NEXT LINE IF RECORD TYPE MATTERS

   //RecordTypeId = ContactRecordType,

/*
   Create a record using ~at least~ the fields that are required to insert an instance of the object
   Make sure to add __c to any field names that are custom to the object
*/
   //replace these with the required fields necessary
   //to insert the object
   Name = 'DialSource',
   Phone__c     = '555-555-5555',
   
   //leave these alone
   Total_Call_Count__c = 3,
   Last_Disposition__c = null,
   Last_Call_Campaign_Name__c = null,
   Datetime_of_Last_Disposition__c = null
  );

Custom_Object__c DSCustomObj2 = new Custom_Object__c(
   
   //UNCOMMENT NEXT LINE IF RECORD TYPE MATTERS

   //RecordTypeId = ContactRecordType,

/*
   Create a record using ~at least~ the fields that are required to insert an instance of the object
   Make sure to add __c to any field names that are custom to the object
*/
   Name = 'DialSource',
   Phone__c     = '555-555-5555',
   Total_Call_Count__c = null,
   Last_Disposition__c = null,
   Last_Call_Campaign_Name__c = null,
   Datetime_of_Last_Disposition__c = null
  );
     
  
  System.debug('This is a new ' + DSCustomObj);
  insert DSCustomObj;
  System.debug('Inserted ' + DSCustomObj + ' 1');
  insert DSCustomObj2;
     
  DS_Denali__DialSource_Sessions_V3__c dsSesh = new DS_Denali__DialSource_Sessions_V3__c();
  dsSesh.Name = '0624b32b-f68d-44bb-9449-b052a916a084 - 5de6f7b01d8f45000b366596';
  insert dsSesh;

  Id dsSeshId = dsSesh.Id;
  
 List<DS_Denali__DialSource_Action__c> actionsList = new List<DS_Denali__DialSource_Action__c>();
  //leave this alone
  
 DS_Denali__DialSource_Action__c t2 = new DS_Denali__DialSource_Action__c(
   DS_Denali__Owner__c = UID,
   DS_Denali__Custom_Object_ID__c = DSCustomObj.Id,
   DS_Denali__Subject__c = 'DialSource Automated Call',
   DS_Denali__Call_Disposition__c = 'Recycle',
   DS_Denali__Call_Campaign__c = 'Test List 2!',
   DS_Denali__DialSource_Session__c = dsSeshId,
   DS_Denali__Call_Ended__c = System.now()
  );
  
  DS_Denali__DialSource_Action__c t3 = new DS_Denali__DialSource_Action__c(
   DS_Denali__Owner__c = UID,
   DS_Denali__Custom_Object_ID__c = DSCustomObj2.Id,
   DS_Denali__Subject__c = 'Mama mia',
   DS_Denali__Call_Disposition__c = 'Here I go again',
   DS_Denali__Call_Campaign__c = 'Test List 2!',
   DS_Denali__DialSource_Session__c = dsSeshId,
   DS_Denali__Call_Ended__c = System.now()
  );
 
 actionsList.add(t2);
 actionsList.add(t3);
     
 

  /*Test.startTest();

  t2.DS_Denali__Subject__c = 'In Progress';
  update t2;
  Test.stopTest();*/
Test.startTest();
  
  insert t2;
  t2.DS_Denali__Subject__c = 'In Progress';
  t2.DS_Denali__Call_Disposition__c = 'Recycle';
  update t2;
  DSActionTriggerHandlerCustom.updateSObjects(actionsList, 'update');
  
  Test.stopTest();
 
 }}