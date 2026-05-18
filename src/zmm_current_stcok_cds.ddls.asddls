@AbapCatalog.sqlViewName: 'ZMMCURRENTSTK'
@AbapCatalog.compiler.compareFilter: true
///@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'show stock'
@Metadata.ignorePropagatedAnnotations: true
define view ZMM_CURRENT_STCOK_CDS 
  as select from I_MaterialStock_2 as A
  {
    key A.Plant,
    key A.Material,
    cast( sum(A.MatlWrhsStkQtyInMatlBaseUnit ) as abap.dec(13,2) ) as closingqty
    
} 
where 
A.MatlDocLatestPostgDate <= $session.system_date 
group by
    A.Plant,
    A.Material

