@AbapCatalog.sqlViewName: 'ZMMPURGROUP'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Show group'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZMM_PURCHASE_GROUP as   select distinct  from I_PurchasingGroup
{
 @ObjectModel.text.element: ['PURCHASINGGROUPNAME']  
 @Search.defaultSearchElement: true 
 @Search.ranking: #HIGH
 @Search.fuzzinessThreshold: 0.8
 ///key cast(PurchasingGroup as abap.char( 4 ) ) as PURCHASINGGROUP,
 key cast(PurchasingGroupName as abap.char( 30 ) ) as PURCHASINGGROUPNAME
 
} group by PurchasingGroupName
