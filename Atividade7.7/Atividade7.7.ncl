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

dirm = "/mnt/c/users/Breno/Documents/INPE/Atividade4.5/"
;dir = "/mnt/c/users/breno/documents/inpe/dados/"

;----------------------- LINHA 1 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp126-2015-2100.nc","r")
var = fm->pr
var = var*86400

;----------------------- LINHA 2 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp245-2015-2100.nc","r")
var2 = fm->pr
var2 = var2*86400

;----------------------- LINHA 3 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp585-2015-2100.nc","r")
var3 = fm->pr
var3 = var3*86400

;----------------------- LINHA 4 -----------------------;

fc = addfile(dirm+"prec-anomalia-1981-2100.nc","r")
var4 = fc->pr
var4 = var4*86400

;----------------------- LINHA 5 -----------------------;

fc = addfile(dirm+"prec-anomaliaSSP370-1981-2100.nc","r")
var5 = fc->pr
var5 = var5*86400

;----------------------- LINHA 6 -----------------------;

fc = addfile(dirm+"prec-anomaliaSSP585-1981-2100.nc","r")
var6 = fc->pr
var6 = var6*86400



;----------------------- LINHA 1 -----------------------;

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


data1 = yclim_order(cod,ti:tf)
data2 = yclim_orderA(cod,ti:tf)
data3 = yclim_orderB(cod,ti:tf)
data4 = yclim_orderC(cod,ti:tf)
data5 = yclim_orderD(cod,ti:tf)
data6 = yclim_orderE(cod,ti:tf)

;*********************************
; create plot
;*********************************

wks   = gsn_open_wks ("png", "LinhaTriplaHadGEM3" )  ; send graphics to PNG file
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade

 
time = ispan(anoi,anof,1)
time@long_name = "Time"

plot = new(3,graphic)    ; create a 4D array


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
res@xyLineThicknesses =  1.5
res@gsnYRefLine = 0.0
res@xyLineColors = (/"red","black"/)
res@tiYAxisFontColor = res@xyLineColors
res@tmYLLabelFontColor = res@xyLineColors
res@xyDashPatterns = (/0/)
res@vpHeightF= 0.70                    ; change aspect ratio of plot
res@vpWidthF = 1
res@tmXTOn = False
res@tiYAxisString = "ssp126" ; y-axis label
res@tiMainString  = "Bacia do "+reg(cod)

res@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 
									 

;----------------------- LINHA 2 -----------------------;

res1 = True
res1@gsnScale = True
res1@gsnDraw  =  False
res1@gsnFrame =  False
res1@tmYROn = True ; e direito
res1@trYMinF = -0.12              ;-- y-axis min value
res1@trYMaxF = 0.12             ;-- y-axis max value
res1@xyXStyle  = "Time"
res1@tmXBMode = "Explicit"         ;-- set line colors
res1@xyMarkLineModes = "Lines"          ;-- line modus
res1@xyLineThicknesses =  1.5
res1@gsnYRefLine = 0.0
res1@xyLineColors = "blue"
res1@tiYAxisFontColor = res1@xyLineColors
res1@tmYLLabelFontColor = res1@xyLineColors
res1@xyDashPatterns = (/0/)
res1@vpHeightF= 0.70                    ; change aspect ratio of plot
res1@vpWidthF = 1
res1@tmXTOn = False
res1@tiYAxisString = "ssp245" ; y-axis label
res1@tiYAxisSide = "Right"
res1@tmYLOn = False
res1@tmYLLabelsOn  = False
res1@tmYRLabelsOn  = True

res1@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 


;----------------------- LINHA 3 -----------------------;

res3 = True
res3@gsnScale = True
res3@gsnDraw  =  False
res3@gsnFrame =  False
res3@tmYROn = False ; e direito
res3@trYMinF = -0.12              ;-- y-axis min value
res3@trYMaxF = 0.12             ;-- y-axis max value
res3@xyXStyle  = "Time"
res3@tmXBMode = "Explicit"         ;-- set line colors
res3@xyMarkLineModes = "Lines"          ;-- line modus
res3@xyLineThicknesses =  2.0
res3@gsnYRefLine = 0.0
res3@xyLineColors = "black"
res3@tiYAxisFontColor = res3@xyLineColors
res3@tmYLLabelFontColor = res3@xyLineColors
res3@xyDashPatterns = (/0/)
res3@vpHeightF= 0.70                    ; change aspect ratio of plot
res3@vpWidthF = 1
res3@tmXTOn = False
res3@tiYAxisString = "ssp585" ; y-axis label

res3@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 
										 
;----------------------- LINHA 4 -----------------------;

res4 = True
res4@gsnScale = True
res4@gsnDraw  =  False
res4@gsnFrame =  False
res4@tmYROn = True ; e direito
res4@trYMinF = -0.12              ;-- y-axis min value
res4@trYMaxF = 0.12             ;-- y-axis max value
res4@xyXStyle  = "Time"
res4@tmXBMode = "Explicit"         ;-- set line colors
res4@xyMarkLineModes = "Lines"          ;-- line modus
res4@xyLineThicknesses =  2.0
res4@gsnYRefLine = 0.0
res4@xyLineColors = "black"
res4@tiYAxisFontColor = res4@xyLineColors
res4@tmYLLabelFontColor = res4@xyLineColors
res4@xyDashPatterns = (/0/)
res4@vpHeightF= 0.70                    ; change aspect ratio of plot
res4@vpWidthF = 1
res4@tmXTOn = False
res4@tiYAxisString = "ssp585" ; y-axis label

res4@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 
	
;----------------------- LINHA 5 -----------------------;

res5 = True
res5@gsnScale = True
res5@gsnDraw  =  False
res5@gsnFrame =  False
res5@tmYROn = True ; e direito
res5@trYMinF = -0.12              ;-- y-axis min value
res5@trYMaxF = 0.12             ;-- y-axis max value
res5@xyXStyle  = "Time"
res5@tmXBMode = "Explicit"         ;-- set line colors
res5@xyMarkLineModes = "Lines"          ;-- line modus
res5@xyLineThicknesses =  1.5
res5@gsnYRefLine = 0.0
res5@xyLineColors = "blue"
res5@tiYAxisFontColor = res5@xyLineColors
res5@tmYLLabelFontColor = res5@xyLineColors
res5@xyDashPatterns = (/0/)
res5@vpHeightF= 0.70                    ; change aspect ratio of plot
res5@vpWidthF = 1
res5@tmXTOn = False
res5@tiYAxisString = "ssp245" ; y-axis label
res5@tiYAxisSide = "Right"
res5@tmYLOn = False
res5@tmYLLabelsOn  = False
res5@tmYRLabelsOn  = True

res5@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 
                   ; before rest of plot. 
	
;----------------------- LINHA 6 -----------------------;

res6 = True
res6@gsnScale = True
res6@gsnDraw  =  False
res6@gsnFrame =  False
res6@tmYROn = False ; e direito
res6@trYMinF = -0.12              ;-- y-axis min value
res6@trYMaxF = 0.12             ;-- y-axis max value
res6@xyXStyle  = "Time"
res6@tmXBMode = "Explicit"         ;-- set line colors
res6@xyMarkLineModes = "Lines"          ;-- line modus
res6@xyLineThicknesses =  2.0
res6@gsnYRefLine = 0.0
res6@xyLineColors = "black"
res6@tiYAxisFontColor = res6@xyLineColors
res6@tmYLLabelFontColor = res6@xyLineColors
res6@xyDashPatterns = (/0/)
res6@vpHeightF= 0.70                    ; change aspect ratio of plot
res6@vpWidthF = 1
res6@tmXTOn = False
res6@tiYAxisString = "ssp585" ; y-axis label

res6@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 
	


;;; ssp126

plot(0) = gsn_csm_xy(wks,time,data1(:),res)

;;; ssp245

plot(1) = gsn_csm_xy(wks,time,data2(:),res1)

;;; ssp585

plot(2) = gsn_csm_xy(wks,time,data3(:),res4)

;------------------------- HadGEM3 -------------------------;

;;; ssp245

plot(3) = gsn_csm_xy(wks,time,data4(:),res)

;;; ssp370

plot(4) = gsn_csm_xy(wks,time,data5(:),res1)

;;; ssp585

plot(5) = gsn_csm_xy(wks,time,data6(:),res2)


;;;;;; Attach plots along the X axes
  attachres1                     = True
  attachres1@gsnAttachPlotsXAxis = True  ;; attaches along x-axis
  attachres1@gsnAttachBorderOn   = False ;; No border please
  attachres2                     = True
  attachres2@gsnAttachPlotsXAxis = True  ;; attaches along x-axis
  attachres2@gsnAttachBorderOn   = False ;; No border please
  
  attachid1  = gsn_attach_plots(plot(0),plot(1:2),attachres1,attachres2)
  attachid2  = gsn_attach_plots(plot(3),plot(4:5),attachres1,attachres2)
  
 ;;;;;; Maximize output on the page and draw everything
  pres = False               ; No resources needed
  maximize_output(wks,pres)  ; Maximize plot on page

end
