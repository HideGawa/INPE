load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"

;------------------------------
; NCL tutorial
; climatology + panel plots
;------------------------------

;-------------------------------------------------
; User specifications
;-------------------------------------------------
wksName = "AnomaliaHistorical"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dir = "/mnt/c/users/breno/documents/inpe/dados/" ; diretorio

begin

;--- open NC file

sname = dir+"regioes_hidrograficas.shp"        ; e nome do shapefile  
f = addfile(sname,"r")
print_shapefile_info(sname)

f = addfile(dir+"historical4.nc","r")  ; "r" = read

;-- read variable
var = f->pr(:,:,:)  ; precip[time,lat,lon] 
var = var*86400

;--- Climatologia Mensal
clim = clmMonTLL(var(0:359,:,:))
var1 := lonFlip(clim) 
printVarSummary(var1)

;--- Anomalia
anom = calcMonAnomTLL(var,var1)


;---- Plots
wks = gsn_open_wks(wks_type,wksName) ;figure name

res = True      ; configuration for plots 
res@gsnDraw = False      ; dont draw plots yet
res@gsnFrame = False     ; dont create figures yet
res@lbLabelBarOn = False ; dont draw individual label bars
res@cnFillOn = True        ; shaded plot
res@cnLinesOn = False      ; no lines
res@cnLineLabelsOn = False ; no label on lines
res@cnFillPalette = "MPL_BrBG"
res@cnLevelSelectionMode = "ManualLevels"  ; sel. levels
res@cnMinLevelValF = -12      ; min value
res@cnMaxLevelValF = 12     ; max value
res@cnLevelSpacingF = 1

res@tmXTOn = False ; remove top tickmarks
res@tmYROn = False ; remove right tickmarks

res@mpMinLatF = -45  ; Zoom in on Brazil
res@mpMaxLatF = 15
res@mpMinLonF = -75
res@mpMaxLonF = -30

;create the plots
res@gsnRightString = "(mm/dia)"
res@gsnLeftString = "Precipita"+cedil+""+atilde+"o"
plot = new(12,graphic)    ; create a 12D array
do i=0,11
  plot(i)= gsn_csm_contour_map(wks,anom(i,:,:),res)
end do

;--- Panel plots - only one figure
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelLabelBar = True ; add a common label bar
panelres@txString = "Anomalia mensal de Precipita"+cedil+""+atilde+"o"
panelres@gsnPanelFigureStrings = (/"Janeiro","Fevereiro","Mar"+cedil+"o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"/)
panelres@gsnPanelTop =  0.95

 ;---Section to add polylines to map.
pres = True                  ; desenha os contornos
pres@gsLineColor = "black"
pres@gsLineThicknessF = 1.0
poly = gsn_add_shapefile_polylines(wks,plot,sname,pres)

;-- create the panel
gsn_panel(wks,plot,(/3,4/),panelres)  ; now draw plots


frame(wks)

end



