load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"

begin

dirm = "/mnt/c/users/Breno/Documents/INPE/Atividade6.2/"
;dir = "/mnt/c/users/breno/documents/inpe/dados/"
fc = addfile(dirm+"prec-anomaliaGPCC-1981-2010.nc","r")      ; add file
var = fc->pr
;var = var*86400

printVarSummary(var)

pr_order = var(time|:,area|:)  ;month_to_annual necessita variavel time no incio

;--- Media anual
yclim = month_to_annual(pr_order,1)
printVarSummary(yclim)
yclim_order = yclim(area|:,year|:)  ;gsn_csm_xy necessita variavel time no final

;print(yclim_order)

printVarSummary(yclim_order)

;*********************************
; create plot
;*********************************
 wks   = gsn_open_wks ("png", "GráficoBarrasGPCC" )  ; send graphics to PNG file
 res   = True
 res@gsnScale = True               

;time = ispan(1850,2014,1)
time = ispan(1981,2010,1)
time@long_name = "Time"

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

; res@vpXF      = 0.10        ; In page coordinates, where to start
; res@vpYF      = 0.75        ; the plot
 res@vpHeightF = 0.43        ; Changes the aspect ratio
 res@vpWidthF  = 0.85
 res@gsnMaximize = True

 ;@trYMinF   = -3.0        ; min value on y-axis
 ;res@trYMaxF   =  3.0        ; max value on y-axis

 res@tiYAxisString = "" ; y-axis label      
 res@tiXAxisString = ""
 res@tiMainString  = "M"+eacute+"dia Mensal" ; title

 res@gsnYRefLine           = 0.              ; reference line   
 res@gsnXYBarChart         = True            ; create bar chart 
 res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
 res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
 
 printVarSummary(time)

 ;plot = gsn_csm_xy (wks,time,yclim_order(0,131:164),res)
 plot = gsn_csm_xy (wks,time,yclim_order(0,:),res)
 
 

end

