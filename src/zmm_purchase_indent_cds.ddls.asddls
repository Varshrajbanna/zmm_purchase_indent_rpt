@AbapCatalog.sqlViewName: 'ZMMPRINDENT'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'show indent details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZMM_PURCHASE_INDENT_CDS
  as select from    I_PurchaseRequisitionItemAPI01 PR
    left outer join I_ProductDescription       as PD  on(
       PD.Product      = PR.Material
       and PD.Language = 'E'
     )
    left outer join I_PurchasingGroup          as PG  on(
       PG.PurchasingGroup = PR.PurchasingGroup
     )
    left outer join I_PurchaseRequisitionAPI01 as PR2 on(
      PR.PurchaseRequisition         = PR.PurchaseRequisition
      and PR.PurchaseRequisitionItem = PR2.PurchaseRequisition
    )
  //left outer join ZMM_PENDINF_NEW as PNQ on  (PNQ.PurchaseRequisition    = PR.PurchaseRequisition and PNQ.PurchaseRequisitionItem = PR.PurchaseRequisitionItem     )
    left outer join I_PurchaseOrderItemAPI01   as I   on(
        I.PurchaseRequisition         = PR.PurchaseRequisition
        and I.PurchaseRequisitionItem = PR.PurchaseRequisitionItem
      )
    left outer join I_PurchaseOrderAPI01       as C   on(
        C.PurchaseOrder = I.PurchaseOrder
      )
    left outer join ZMM_PURCHASE_STORE_CD      as GRN on(
      GRN.PurchaseOrder         = C.PurchaseOrder
      and I.PurchaseOrder       = GRN.PurchaseOrder
      and GRN.PurchaseOrderItem = I.PurchaseOrderItem
    )
    ///left outer join  ZMM_CURRENT_STCOK_CDSPURCHASE( To_Date:$parameters.To_Date ) as STK on (STK.Material = PR.Material and STK.Plant = PR.Plant     )
   
    
   left outer join ZMM_CURRENT_STCOK_CDS   as STK on (STK.Material = PR.Material and STK.Plant = PR.Plant     )
   /* left outer join I_MaterialDocumentItem_2   as mt  on  mt.PurchaseOrder     = GRN.PurchaseOrder
                                                      and mt.PurchaseOrderItem = I.PurchaseOrderItem
                                                      and mt.Plant = PR.Plant
                                                      and mt.PurchaseOrder = C.PurchaseOrder */
                                                      
  left outer join I_InspectionLot            as ins on  ins.Material             = PR.Material
                                                     // and ins.MaterialDocument     = mt.MaterialDocument
                                                     // and ins.MaterialDocumentItem = mt.MaterialDocumentItem
                                                      and ins.Plant = PR.Plant
                                                      and ins.PurchasingDocument = I.PurchaseOrder
  left outer join I_InspLotUsageDecision as LT on LT.InspectionLot = ins.InspectionLot  and ins.Plant = PR.Plant
  left outer join      I_User                     as iu  on iu.UserID = PR.CreatedByUser                                 
    //inner join      I_User                     as iu  on iu.UserID = PR.CreatedByUser

{

          @UI.lineItem             : [{ position: 10 }]@EndUserText.label       : 'Plant'@UI.selectionField       : [{position: 10 }]
          @Consumption.filter.mandatory: true
          @Consumption.valueHelpDefinition: [ { entity:  { name:    'ZPLANT_F4',element: 'Plant' }
             }]
  key     PR.Plant,
          @UI.lineItem             : [{ position: 20 }]
          @EndUserText.label       : 'Indent No'
          //@UI.selectionField       : [{position: 10 }]
  key     PR.PurchaseRequisition,

          @UI.selectionField       : [{position: 30 }]
          @UI.lineItem             : [{ position: 30 }]
          @EndUserText.label       : 'Indent Date'
  key     PR.CreationDate,
          @UI.lineItem             : [{ position: 40 }]
          @EndUserText.label       : 'Item Sno'
  key     PR.PurchaseRequisitionItem,

          @UI.lineItem             : [{ position: 50 }]
          @EndUserText.label       : 'Material Code'
  key     PR.Material,

          @UI.lineItem             : [{ position: 60 }]
          @EndUserText.label       : 'Item Name'
    key      PD.ProductDescription,

          @UI.lineItem             : [{ position: 70 }]
          @EndUserText.label       : 'UOM'
       key   PR.BaseUnit,

       
           @UI.lineItem             : [{ position: 80 }]
           @EndUserText.label       : 'Current Stock'
            STK.closingqty,
          
          @UI.lineItem             : [{ position: 90 }]
          @EndUserText.label       : 'Indent Qty'
          PR.RequestedQuantity,
          

          @UI.lineItem             : [{ position: 100 }]
          @EndUserText.label       : 'PO Qty.'
          cast(sum(I.OrderQuantity)     as abap.dec( 23, 2 ) )         as PoQuantity,

          @UI.lineItem             : [{ position: 110 }]
          @EndUserText.label       : 'GRN Quantity'
          cast(sum(GRN.QuantityInBaseUnit)     as abap.dec( 23, 2 ) )  as GRN_QTY,


          @UI.lineItem             : [{ position: 120 }]
          @EndUserText.label       : 'Pending Qty'
          (PR.RequestedQuantity ) - coalesce(GRN.QuantityInBaseUnit,0) as PENDING_QTY,

          //  @UI.lineItem             : [{ position: 120 }]
          // @EndUserText.label       : 'Indent By'
          //  PR.RequisitionerName,

          @UI.lineItem             : [{ position: 130 }]
          @EndUserText.label       : 'Indent By'
          @UI.selectionField       : [{position: 130 }]
          @Consumption.valueHelpDefinition: [
          { entity:  { name:    'ZMM_INDENT_USER_F4',
                    element: 'UserDescription' }
          }]
         case when iu.UserDescription is not null  then
         iu.UserDescription
         when iu.UserDescription is  null  then
         'System auto-generated'
         else
         '-'
          end as IUSERDESSHOW,
          @UI.lineItem             : [{ position: 140 }]
          @EndUserText.label       : 'Purchase Group'
          @UI.selectionField       : [{position: 140 }]
          @Consumption.valueHelpDefinition: [
          { entity:  { name:    'ZMM_PURCHASE_GROUP',
                    element: 'PURCHASINGGROUPNAME' }
          }]
          PG.PurchasingGroupName                                       as INDENTTYPE,
        @UI.lineItem             : [{ position: 150 }]
        @EndUserText.label       : 'Lot Status'
        case when  LT.InspectionLotUsageDecisionCode like'%A%' then
        'Approved'
       when  LT.InspectionLotUsageDecisionCode like'%R%' then
      'Rejected'
       when  LT.InspectionLotUsageDecisionCode is null  then
        'Pending'
        end as INLLOT
        
        

          ///     techdesc as vdm_userdescription

}
where
      PD.ProductDescription is not null
  and PR.IsDeleted          <> 'X'
  and PR.IsClosed           <> 'X'
group by
  PR.PurchaseRequisition,
  PR.CreationDate,
  PR.PurchaseRequisitionItem,
  PR.Material,
  PD.ProductDescription,
  PR.RequestedQuantity,
  PR.BaseUnit,
  PR.RequisitionerName,
  iu.UserDescription,
  PG.PurchasingGroupName,
  PR.Plant,
  I.OrderQuantity,
  GRN.QuantityInBaseUnit,
  LT.InspectionLotUsageDecisionCode,
     STK.closingqty
     ////stk.closingqty
