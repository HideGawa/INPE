;-------------------------------------------------------
; Plot NE e N basins 
; and annual precipitation
;-------------------------------------------------------
load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ;

begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------
palT1  = "GMT_drywet"  ; paleta de cores
   
dirc = "/mnt/c/users/breno/documents/inpe/dados/" ; Mudar 
;dir  = "/mnt/c/users/arthur/documents/ic/4.3/"; diretorios
sname = dirc+"regioes_hidrograficas.shp"        ; e nome do shapefile  
f = addfile(sname,"r")

;-------------------shapefiles estados Brasil------------------------------------

g = addfile(dirc + "regioes_hidrograficas.shp", "r") ;
shname = dirc+"regioes_hidrograficas.shp"
print_shapefile_info(shname)
var = g->rhi_cd(:)
print(var)

;-------------------------------------------------------

wks_type = "png"
wks_type@wkWidth  = 5500  ; usado para figura em alta
wks_type@wkHeight = 5500  ; resolucao
wksName = "fig-regioes"

;-----------------------------------------------------
; Read in netCDF files
;-----------------------------------------------------
fc = addfile(dirc+"chirps.nc","r")
vp = fc->precip(:,:,:)

;---Comandos para salvar apenas os dados sobre o estado
dims = dimsizes(vp) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "rhi_cd"  ; variavel do shapefile
opt@shape_names = (/"10"/)     ; codigo do estado
prec_mask       = shapefile_mask_data(vp(0,:,:),shname,opt)
copy_VarMeta(vp(0,:,:),prec_mask)
m3 := conform_dims(dimsizes(vp),prec_mask,(/1,2/))  ; 3Dmask
n1 := mask(vp,m3,1)


;-- annual mean
vm = dim_avg_n_Wrap(n1,0)

;-------------------------------------------------------
; create plots
;-------------------------------------------------------
wks = gsn_open_wks(wks_type,wksName) 
setvalues NhlGetWorkspaceObjectId() ; usado para chirps
   "wsMaximumSize" : 800000000
end setvalues

res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnRightString = ""
res@gsnLeftString = ""
res@cnLineLabelsOn = False
res@cnFillOn = True         
res@cnLinesOn = False
res@cnFillPalette = palT1
res@mpMinLatF = -45  ; Zoom in on SP
res@mpMaxLatF = 15
res@mpMinLonF = -85
res@mpMaxLonF = -30
res@cnFillMode = "RasterFill"
res@cnFillDrawOrder = "Predraw"
res@cnSpanFillPalette = True
;res@cnLevelSelectionMode = "ManualLevels"
res@cnMaxLevelValF = 10     ; mudar valores maximos
res@cnMinLevelValF = 0      ; e intervalo
;res@cnLevelSpacingF = 0.5
res@tmYROn = False
res@tmXTOn = False

; Zoom in SP
res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpFillBoundarySets = "NoBoundaries"
res@mpFillAreaSpecifiers = (/"Land","brazil","Water"/)
res@mpSpecifiedFillColors = (/"white","transparent",       "white"/)
res@mpOutlineOn = False

plot = gsn_csm_contour_map(wks,vm,res)

;---Section to add polylines to map.
pres = True                  ; desenha os contornos
pres@gsLineColor = "black"
pres@gsLineThicknessF = 6.0
poly = gsn_add_shapefile_polylines(wks,plot,shname,pres)


draw(plot)

;------------------ Plot Area names
txres = True
txres@txFontColor = "white"  ; muda a cor da fonte
txres@txFont = 22
txres@txFontHeightF = 0.02  ; muda o tamanho da fonte 
;--- Identificar cada regiao com um numero
;-- mudar os valores x e y para ficar dentro
;--- de cada regiao 
;--- gsn_text_ndc(wks,text,x,y,res)
gsn_text_ndc(wks,"5",  0.52, 0.54, txres);Ararar!
gsn_text_ndc(wks,"2",  0.56, 0.605, txres);Rib P!
gsn_text_ndc(wks,"3",  0.36,  0.61, txres);Araça !
gsn_text_ndc(wks,"4",  0.465,  0.48, txres);Bauru!
gsn_text_ndc(wks,"1",  0.43,  0.62, txres);SJRP!
gsn_text_ndc(wks,"6",  0.53, 0.50, txres);Pirac!
gsn_text_ndc(wks,"7",  0.60,  0.50, txres);Camp!
gsn_text_ndc(wks,"8",  0.33,  0.54, txres);Prudente!
gsn_text_ndc(wks,"9",  0.37,  0.54, txres);Marilia!
gsn_text_ndc(wks,"10", 0.42,  0.48, txres);Assis   
gsn_text_ndc(wks,"11", 0.465,  0.40, txres);Itapet!
gsn_text_ndc(wks,"12", 0.555,  0.44, txres);Macro Metropolitana
gsn_text_ndc(wks,"13", 0.70,  0.46, txres);Vale do para!
gsn_text_ndc(wks,"14", 0.58,  0.38, txres);Litoral sul 
gsn_text_ndc(wks,"15", 0.62,  0.42, txres);Metropolitana   
txres@txFontHeightF = 0.012

frame(wks)

end