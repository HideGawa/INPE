load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"

begin

;----------------------- LINHA 1 -----------------------;

dirm = "/mnt/c/users/Breno/Documents/INPE/Atividade4.5/"
;dir = "/mnt/c/users/breno/documents/inpe/dados/"
fc = addfile(dirm+"prec-anomaliaSSP370-1981-2100.nc","r")
var = fc->pr
var = var*86400
;----------------------- LINHA 2 -----------------------;

fm = addfile(dirm+"prec-anomaliaSSP585-1981-2100.nc","r")
var2 = fm->pr
var2 = var2*86400

fm = addfile(dirm+"prec-anomalia-1981-2100.nc","r")
var3 = fm->pr
var3 = var3*86400

dir = "/mnt/c/users/breno/documents/inpe/dados/"
f = addfile(dir + "regioes_hidrograficas.shp", "r") 
sname = dir+"regioes_hidrograficas.shp"

cod = (/"12","3","9","4","10","2","5","6","8","11","1","7"/)
reg = (/"Uruguai","Atl"+acirc+"ntico Nordeste Ocidental","Parna"+iacute+"ba","Atl"+acirc+"ntico Nordeste Oriental","S"+atilde+"o Francisco","Atl"+acirc+"ntico Leste","Atl"+acirc+"ntico Sudeste","Atl"+acirc+"ntico Sul","Paran"+iacute+"","Tocantins-Araguaia","Amaz"+ocirc+"nica","Paraguai"/)

;----------------------- LINHA 1 -----------------------;

printVarSummary(var)

pr_order = var(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim = month_to_annual(pr_order,1)
printVarSummary(yclim)
yclim_order = yclim(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

;print(yclim_order)

printVarSummary(yclim_order)

;----------------------- LINHA 2 -----------------------;

pr_orderA = var2(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim2 = month_to_annual(pr_orderA,1)
printVarSummary(yclim2)
yclim_orderA = yclim2(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

printVarSummary(yclim_orderA)

;----------------------- LINHA 3 -----------------------;

pr_orderB = var3(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim3 = month_to_annual(pr_orderB,1)
printVarSummary(yclim3)
yclim_orderB = yclim3(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

printVarSummary(yclim_orderB)

;----------------------- CRIANDO MATRIZ -----------------------;

data = new((/12,3,120/),float)

data(:,0,:) = yclim_order(:,:)
data(:,1,:) = yclim_orderA(:,:)
data(:,2,:) = yclim_orderB(:,:)


;*********************************
; create plot
;*********************************

wks   = gsn_open_wks ("png", "GráficoLinhaTeste" )  ; send graphics to PNG file


 
labels  =  (/"Anomalia"/)       	  ;-- line labels
color1  =  (/"red"/)                  ;-- line colors
color2  =  (/"blue"/)                 ;-- line colors
color3  =  (/"green"/)
 
time = ispan(1981,2100,1)
time@long_name = "Time"

plot = new(12,graphic)    ; create a 4D array

;----------------------- LINHA 1 -----------------------;

res = True
res@gsnScale = True
res@gsnDraw  =  False
res@gsnFrame =  False
res@tmYROn = False ; e direito
res@trYMinF = -0.12              ;-- y-axis min value
res@trYMaxF = 0.12             ;-- y-axis max value
res@xyXStyle  = "Time"
res@tmXBMode = "Explicit"         ;-- set line colors
res@xyMarkLineModes = "Lines"          ;-- line modus
res@xyLineThicknesses =  (/2.5, 3.0, 2.5/)
res@gsnYRefLine           = 0.0
res@xyLineColors      = (/"blue","red","black"/)
res@xyDashPatterns = (/0/)
res@vpHeightF= 0.4                    ; change aspect ratio of plot
res@vpWidthF = 0.8
res@tmXTOn = False


do i=0,11	
	res@tiMainString  = reg(i)	
	plot(i) = gsn_csm_xy (wks,time,data(i,:,:),res)
end do

;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnFrame = False
 panelres@gsnPanelTop =  0.95
 panelres@txString = "Anomalia M"+eacute+"dia Anual"
 
 
 ;-- create the panel
gsn_panel(wks,plot,(/1,1/),panelres)  ; now draw plots

frame(wks)

end
