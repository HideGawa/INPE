load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"
begin


reg = (/"Uruguai","Atl"+acirc+"ntico Nordeste Ocidental","Parna"+iacute+"ba","Atl"+acirc+"ntico Nordeste Oriental","S"+atilde+"o Francisco","Atl"+acirc+"ntico Leste","Atl"+acirc+"ntico Sudeste","Atl"+acirc+"ntico Sul","Paran"+iacute+"","Tocantins-Araguaia","Amaz"+ocirc+"nica","Paraguai"/)
anoi = toint(getenv("ano_inicial")) ;para o painel colocar de 2018 a 2020
anof = toint(getenv("ano_final"))
cod = toint(getenv("cod"))

ti = (anoi - 1981)         ; Jan anoi (colocar ano inicial do arquivo no lugar do 1979)
tf = (anof - 1981)  ; Dec anof
nt = ((anof - anoi) + 1) ; numero de tempos
nyears = (anof - anoi) + 1    ; numero de anos

wksName = "São Francisco 2001 historical" ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dirm = "/mnt/c/users/Breno/Documents/INPE/Atividade4.5/"

;----------------------- LINHA 1 -----------------------;

dirm = "/mnt/c/users/Breno/Documents/INPE/Atividade4.5/"
;dir = "/mnt/c/users/breno/documents/inpe/dados/"
fc = addfile(dirm+"prec-anomalia-1981-2100.nc","r")
var = fc->pr
var = var*86400
;----------------------- LINHA 2 -----------------------;

fm = addfile(dirm+"prec-anomaliaSSP370-1981-2100.nc","r")
var2 = fm->pr
var2 = var2*86400

;----------------------- LINHA 3 -----------------------;

fm = addfile(dirm+"prec-anomaliaSSP585-1981-2100.nc","r")
var3 = fm->pr
var3 = var3*86400

;----------------------- LINHA 4 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp126-2015-2100.nc","r")
var4 = fm->pr
var4 = var4*86400

;----------------------- LINHA 5 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp245-2015-2100.nc","r")
var5 = fm->pr
var5 = var5*86400

;----------------------- LINHA 6 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp585-2015-2100.nc","r")
var6 = fm->pr
var6 = var6*86400

;-------------------------------------------------------;

print(var)
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

;----------------------- LINHA 3 -----------------------;

pr_orderC = var4(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim4 = month_to_annual(pr_orderC,1)
printVarSummary(yclim4)
yclim_orderC = yclim4(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

printVarSummary(yclim_orderC)

;----------------------- LINHA 3 -----------------------;

pr_orderD = var5(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim5 = month_to_annual(pr_orderD,1)
printVarSummary(yclim5)
yclim_orderD = yclim5(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

printVarSummary(yclim_orderD)

;----------------------- LINHA 3 -----------------------;

pr_orderE = var6(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim6 = month_to_annual(pr_orderE,1)
printVarSummary(yclim6)
yclim_orderE = yclim6(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

printVarSummary(yclim_orderE)


;----------------------- CRIANDO MATRIZ -----------------------;

data = new((/6,nt/),float)

printVarSummary(data)
printVarSummary(yclim_order(cod,ti:tf))

data(0,:) = yclim_order(cod,ti:tf)
data(1,:) = yclim_orderA(cod,ti:tf)
data(2,:) = yclim_orderB(cod,ti:tf)
data(3,:) = yclim_orderC(cod,ti:tf)
data(4,:) = yclim_orderD(cod,ti:tf)
data(5,:) = yclim_orderE(cod,ti:tf)


;*********************************
; create plot
;*********************************

wks   = gsn_open_wks ("png", "GráficoLinha" )  ; send graphics to PNG file

 
time = ispan(anoi,anof,1)
time@long_name = "Time"

plot = new(1,graphic)    ; create a 4D array

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
res@xyLineThicknesses =  (/2.5, 3.0, 2.5, 3.0, 3.0, 3.0/)
res@gsnYRefLine           = 0.0
res@xyLineColors      = (/"red","blue","black","darkgreen","purple","orange"/)
res@xyDashPatterns = (/0/)
res@vpHeightF= 0.4                    ; change aspect ratio of plot
res@vpWidthF = 0.8
res@tmXTOn = False
res@tiYAxisString = "mm/ano" ; y-axis label 


;do i=0,11	
	res@tiMainString  = reg(cod)
	plot = gsn_csm_xy (wks,time,data(:,:),res)
;end do

;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnFrame = False
 panelres@tiYAxisString = "mm/ano" ; y-axis label 
 panelres@gsnPanelTop =  0.95
 panelres@txString = "Anomalia M"+eacute+"dia Anual"
 
 colors = (/"red","blue","black","darkgreen","purple","orange"/)
 
 
 gsres = True
 gsres@gsLineThicknessF = 5

 
 txres = True
 txres@txFontHeightF = 0.01
 txres@txFontSize
 txres@txJust = "CenterLeft"
 nsrc = (/"Hist"+oacute+"rico","SSP370","SSP585","SSP126","SSP245","SSP585"/)
 text1 = (/"SSP585"/)
 
 
 ;x3 = (/.66,.73/)
 xt = (/.28,.51,.74,.28,.51,.74/)
 y  = (/.97,.97,.97,.93,.93,.93/) 
 

 
 do i=0,5
 gsres@gsLineColor = colors(i)
 gsn_polyline_ndc(wks,(/x(i),x2(i)/),(/y(i),y(i)/),gsres)
 gsn_text_ndc    (wks,nsrc(i),xt(i),y(i),txres)
 end do
 
 ;-- create the panel
gsn_panel(wks,plot,(/1,1/),panelres)  ; now draw plots

frame(wks)

end
