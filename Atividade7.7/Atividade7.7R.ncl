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
var1 = fm->pr(cod,:) ; com o cod, ja seleciona a area
var1 = var1*86400
yclim1 = month_to_annual(var1,1)

;----------------------- LINHA 2 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp245-2015-2100.nc","r")
var2 = fm->pr(cod,:)
var2 = var2*86400
yclim2 = month_to_annual(var2,1)

;----------------------- LINHA 3 -----------------------;

fm = addfile(dirm+"prec-anomaliaHadGEM3ssp585-2015-2100.nc","r")
var3 = fm->pr(cod,:)
var3 = var3*86400
yclim3 = month_to_annual(var3,1)

;----------------------- LINHA 4 -----------------------;

fc = addfile(dirm+"prec-anomalia-1981-2100.nc","r")
var4 = fc->pr(cod,:)
var4 = var4*86400
yclim4 = month_to_annual(var4,1)

;----------------------- LINHA 5 -----------------------;

fc = addfile(dirm+"prec-anomaliaSSP370-1981-2100.nc","r")
var5 = fc->pr(cod,:)
var5 = var5*86400
yclim5 = month_to_annual(var5,1)

;----------------------- LINHA 6 -----------------------;

fc = addfile(dirm+"prec-anomaliaSSP585-1981-2100.nc","r")
var6 = fc->pr(cod,:)
var6 = var6*86400
yclim6 = month_to_annual(var6,1)

;----------------------- CRIANDO MATRIZ -----------------------;
; criar matriz unica, a ordem dos elementos deve ser:
; modelo1-ssp245, modelo2-ssp245, media
; modelo1-ssp370, modelo2-ssp370, media
; modelo1-ssp585, modelo2-ssp585, media

data = new((/9,nyears/),float) ; modelos+media, areas, time

;ssp245
data(0,:) = yclim1(ti:tf)
data(1,:) = yclim4(ti:tf)
data(2,:) = dim_avg_n_Wrap(data(0:1,:),0) ; media
;ssp370
data(3,:) = yclim2(ti:tf)
data(4,:) = yclim5(ti:tf)
data(5,:) = dim_avg_n_Wrap(data(3:4,:),0) ; media
;ssp585
data(6,:) = yclim3(ti:tf)
data(7,:) = yclim6(ti:tf)
data(8,:) = dim_avg_n_Wrap(data(6:7,:),0) ; media

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
res@xyLineThicknesses =  (/1,1,3/)
res@gsnYRefLine = 0.0
res@xyLineColors = (/"red","blue","black"/)
res@tiYAxisFontColor = "black"
res@tmYLLabelFontColor = "black"
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
res1@xyLineThicknesses =  (/1,1,3/)
res1@gsnYRefLine = 0.0
res1@xyLineColors = (/"red","blue","black"/)
res1@tiYAxisFontColor = "black"
res1@tmYLLabelFontColor = "black"
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

res2 = True
res2@gsnScale = True
res2@gsnDraw  =  False
res2@gsnFrame =  False
res2@tmYROn = False ; e direito
res2@trYMinF = -0.12              ;-- y-axis min value
res2@trYMaxF = 0.12             ;-- y-axis max value
res2@xyXStyle  = "Time"
res2@tmXBMode = "Explicit"         ;-- set line colors
res2@xyMarkLineModes = "Lines"          ;-- line modus
res2@xyLineThicknesses =  (/1,1,3/)
res2@gsnYRefLine = 0.0
res2@xyLineColors = (/"red","blue","black"/)
res2@tiYAxisFontColor = "black"
res2@tmYLLabelFontColor = "black"
res2@xyDashPatterns = (/0/)
res2@vpHeightF= 0.70                    ; change aspect ratio of plot
res2@vpWidthF = 1
res2@tmXTOn = False
res2@tiYAxisString = "ssp585" ; y-axis label

res2@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
                                         ; before rest of plot. 
										 


;;; ssp126

plot(0) = gsn_csm_xy(wks,time,data(0:2,:),res)

;;; ssp245

plot(1) = gsn_csm_xy(wks,time,data(3:5,:),res1)

;;; ssp585

plot(2) = gsn_csm_xy(wks,time,data(6:8,:),res2)




 gsres = True
 gsres@gsLineThicknessF = 5

 txres = True
 txres@txFontHeightF = 0.015
 txres@txJust = "CenterLeft"
 nsrc = (/"HadGEM3","CESM2","M"+eacute+"dia"/)
 
 x  = (/.80,.80,.80/) 
 x2 = (/.87,.87,.87/) 
 xt = (/.88,.88,.88/) 
 y  = (/.90,.87,.84/)
 
 colors = (/"red","blue","black"/)

do i=0,2
	gsres@gsLineColor = colors(i)
	gsn_polyline_ndc(wks,(/x(i),x2(i)/),(/y(i),y(i)/),gsres)
	gsn_text_ndc(wks,nsrc(i),xt(i),y(i),txres)
end do

;------------------------- HadGEM3 -------------------------;

;;; ssp245

;plot(3) = gsn_csm_xy(wks,time,data4(:),res)

;;; ssp370

;plot(4) = gsn_csm_xy(wks,time,data5(:),res1)

;;; ssp585

;plot(5) = gsn_csm_xy(wks,time,data6(:),res2)


;;;;;; Attach plots along the X axes
  attachres1                     = True
  attachres1@gsnAttachPlotsXAxis = True  ;; attaches along x-axis
  attachres1@gsnAttachBorderOn   = False ;; No border please
  attachres2                     = True
  attachres2@gsnAttachPlotsXAxis = True  ;; attaches along x-axis
  attachres2@gsnAttachBorderOn   = False ;; No border please
  
  attachid1  = gsn_attach_plots(plot(0),plot(1:2),attachres1,attachres2)
;  attachid2  = gsn_attach_plots(plot(3),plot(4:5),attachres1,attachres2)
  
 ;;;;;; Maximize output on the page and draw everything
  pres = False               ; No resources needed
  maximize_output(wks,pres)  ; Maximize plot on page

end
