@AbapCatalog.sqlViewName: 'ZMMUSERF4'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Show user  F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZMM_INDENT_USER_F4 as select distinct  from ZMM_PURCHASE_INDENT_CDS as U
{
      key case when   U.IUSERDESSHOW is not null  then
         U.IUSERDESSHOW
         when U.IUSERDESSHOW  is  null  then
         'System auto-generated'
         else
         '-'
          end as UserDescription     
   /// key ius.UserDescription 
   }group by 
 U.IUSERDESSHOW
 