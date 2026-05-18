@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'STOCK'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_CURRENT_STCOK_CDSPURCHASE with parameters   
    To_Date : zdate
     as select from ZCLOSING_CDS_DATA2( To_Date:$parameters.To_Date  )
{
    key Plant,
    key Material,
    
   StorageLocation,
    MaterialBaseUnit,
    sum(closingqty) as closingqty,
    sum(closing_value) as closing_value
}
group by
    Plant,
    Material,
    
   StorageLocation,
    MaterialBaseUnit
