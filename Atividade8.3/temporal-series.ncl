;-------------------------------------------------
; Plot serie temporal de precipitacao
;-------------------------------------------------
begin

;-------------------------------------------------
; User specifications
;-------------------------------------------------


wksName = "temporal-series"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
dird = "/mnt/c/users/Breno/Documents/INPE/Atividade8.2/" ; diretorio

;----------------------------------------------
; Media espacial
; -- media ponderada (devido a forma da Terra)
; -- peso = cosseno da latitude
;----------------------------------------------

;--- Ler arquivo e variavel
fm = addfile(dird+"anomaliaCESM2_historical-ssp245_1981-2100.nc","r")
vm = fm->pr
printVarSummary(vm)

;--- Media anual
yclim = month_to_annual(vm,0)
printVarSummary(yclim)

;-----------------------------------------
; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------
time = yyyymm_time(1981, 2100, "integer")
time@long_name = "Time"

timey = ispan(1981,2100,1)
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
resR@trXMinF =  198101 ; valor minimo do eixo X 

;--- plot media mensal
xy_plot(0) = gsn_csm_xy (wks,time,yclim,resR)

;--- plot media anual
resR@trXMinF =  1981 ; valor minimo do eixo X 
;xy_plot(0) = gsn_csm_xy (wks,timey,vm,resR)


end

