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
fm = addfile(dirm+"prec-anomaliaHadGEM3ssp585-2015-2100.nc","r")
var = fm->pr
var = var*86400

;-------------------------------------------------------;

;print(var)
;printVarSummary(var)

pr_order = var(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim = month_to_annual(pr_order,1)
printVarSummary(yclim)
yclim_order = yclim(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

;print(yclim_order)

printVarSummary(yclim_order)


;----------------------- CRIANDO MATRIZ -----------------------;

data = new((/1,nt/),float)

printVarSummary(data)
printVarSummary(yclim_order(cod,ti:tf))

data(0,:) = yclim_order(cod,ti:tf)


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
res@xyLineThicknesses = (/2.5/)
res@gsnYRefLine = 0.0
res@xyLineColors = (/"red"/)
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
 panelres@txString = "Anomalia M"+eacute+"dia Anual HadGEM3"
 colors = (/"red"/)


 gsres = True
 gsres@gsLineThicknessF = 5

 
 txres = True
 txres@txFontHeightF = 0.02
; txres@txFontSize
 txres@txJust = "CenterLeft"
 nsrc = (/"ssp585"/)
 
 x  = (/.80/) 
 x2 = (/.87/) 
 xt = (/.88/) 
 y  = (/.90/)
 

 do i=0,0
 gsres@gsLineColor = colors
 gsn_polyline_ndc(wks,(/x,x2(i)/),(/y(i),y(i)/),gsres)
 gsn_text_ndc    (wks,nsrc(i),xt(i),y(i),txres)
 end do
 
 ;-- create the panel
gsn_panel(wks,plot,(/1,1/),panelres)  ; now draw plots

frame(wks)

end
