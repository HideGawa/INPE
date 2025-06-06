load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"

;-------------------------------------------------
; Plot serie temporal de precipitacao
;-------------------------------------------------
begin

;-------------------------------------------------
; User specifications
;-------------------------------------------------
lata = -90  ; define lat-lon
latb = 90   ; para calculo
lona = 0    ; das medias
lonb = 360  ; espaciais

wksName = "temporal-series"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dirm = "/mnt/c/users/breno/documents/inpe/dados/" ; diretorio

;----------------------------------------------
; Media espacial
; -- media ponderada (devido a forma da Terra)
; -- peso = cosseno da latitude
;----------------------------------------------

;--- Ler arquivo e variavel
fm = addfile(dirm+"gpcp.nc","r")
vm = fm->precip

;--- Media anual
yclim = month_to_annual(vm,0)

;--- para a media ponderada
lat = fm->lat      
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat
	 
;--- media espacial ponderada
media = wgt_areaave(vm(:,{lata:latb},{lona:lonb}),clat({lata:latb}),1.0,1)

;--- media espacial ponderada e media anual
ymedia = wgt_areaave(yclim(:,{lata:latb},{lona:lonb}),clat({lata:latb}),1.0,1)

;-----------------------------------------
; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------
time = yyyymm_time(1979, 2019, "integer")
time@long_name = "Time"


timey = ispan(1979,2019,1)
timey@long_name = "Time"

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)
xy_plot  = new(2,graphic)  ; xy line plots

resR = True
resR@xyLineThicknessF = 4.0  ; espessura da linha
resR@xyDashPattern = 0       ; tipo de tracejado   
resR@xyLineColor = "red"     ; cor da linha

resR@tmXTOn = False ; sem eixos superior
resR@tmYROn = False ; e direito
resR@tiYAxisString = "Precipitacao (mm/dia)"
resR@trXMinF =  197901 ; valor minimo do eixo X 

;--- plot media mensal

xy_plot(0) = gsn_csm_xy (wks,time,media,resR)

;--- plot media anual
resR@trXMinF =  1979 ; valor minimo do eixo X 
xy_plot(0) = gsn_csm_xy (wks,timey,ymedia,resR)


end

