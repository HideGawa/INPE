;------------------------------
; NCL tutorial
; climatology + panel plots
;------------------------------

;-------------------------------------------------
; User specifications
;-------------------------------------------------
wksName = "climatologiaGpcc"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dir = "/mnt/c/users/breno/documents/inpe/dados/" ; diretorio

begin

;--- open NC file
f = addfile(dir+"gpcc.nc","r")  ; "r" = read

;-- read variable
var = f->precip(0:359,:,:)  ; precip[time,lat,lon] 

;--- Monthly climatology
clim = clmMonTLL(var)
printVarSummary(clim)

;---- Plots
wks = gsn_open_wks(wks_type,wksName) ;figure name

res = True      ; configuration for plots 

res@gsnDraw = False      ; dont draw plots yet
res@gsnFrame = False     ; dont create figures yet

res@lbLabelBarOn = False ; dont draw individual label bars

res@cnFillOn = True        ; shaded plot
res@cnLinesOn = False      ; no lines
res@cnLineLabelsOn = False ; no label on lines
res@cnFillPalette = "precip_11lev"
res@cnLevelSelectionMode = "ManualLevels"  ; sel. levels
res@cnMinLevelValF = 0      ; min value
res@cnMaxLevelValF = 500     ; max value
res@cnLevelSpacingF = 50

res@tmXTOn = False ; remove top tickmarks
res@tmYROn = False ; remove right tickmarks

res@mpMinLatF = -60          ; for South
res@mpMaxLatF = 15           ; America
res@mpMinLonF = -90
res@mpMaxLonF = -30

;create the plots
res@gsnRightString = "(mm/dia)"
res@gsnLeftString = "Precipitacao"
plot = new(12,graphic)    ; create a 12D array
do i=0,11
  plot(i)= gsn_csm_contour_map(wks,clim(i,:,:),res)
end do

;--- Panel plots - only one figure
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelLabelBar = True ; add a common label bar
panelres@gsnPanelFigureStrings = (/"January","February","March","April","May","June", "July","August","September","October","November","December"/)
panelres@gsnPanelTop =  0.95

;-- create the panel
gsn_panel(wks,plot,(/3,4/),panelres)  ; now draw plots


frame(wks)

end



