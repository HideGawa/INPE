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
lona = -180    ; das medias
lonb = 180  ; espaciais



wksName = "temporal-series"         ; nome da figura
wks_type          = "png"
wks_type@wkWidth  = 2500  ; para figura com
wks_type@wkHeight = 2500  ; maior qualidade
 ; diretorio

;----------------------------------------------
; Media espacial
; -- media ponderada (devido a forma da Terra)
; -- peso = cosseno da latitude
;----------------------------------------------

;--- Ler arquivo e variavel shapefiles
dir = "/mnt/c/users/breno/documents/inpe/dados/"
f = addfile(dir + "regioes_hidrograficas.shp", "r")
sname = dir+"regioes_hidrograficas.shp"
var = f->rhi_cd(:)

cod = (/"12","3","9","4","10","2","5","6","8","11","1","7"/)

;--- Ler arquivo e variavel
dirm = "/mnt/c/users/breno/documents/inpe/dados/"
fm = addfile(dirm+"gpcc.nc","r")
vm = fm->precip

vm := lonFlip(vm) 

ymedia = new((/12,39/),float) ;Area, Tempo

;--- Media anual
yclim = month_to_annual(vm,0)

;--- para a media ponderada
lat = fm->lat      
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

printVarSummary(yclim)

;---Comandos para salvar apenas os dados sobre o estado, funciona para apenas um tempo
dims = dimsizes(yclim) 
opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "rhi_cd"  ; variavel do shapefile
	 
do j=0,11
	opt@shape_names = cod(j)     ; codigo da região - (0) colocar (j) quando começar a repetição
	prec_mask      := shapefile_mask_data(yclim(0,:,:),sname,opt)
	copy_VarMeta(yclim(0,:,:),prec_mask)
	m3 := conform_dims(dimsizes(yclim),prec_mask,(/1,2/))  ; 3Dmask
	n1 :=  mask(yclim,m3,1); (":=" força sobreescrever a variavel)

;--- media espacial ponderada e media anual
ymedia(j,:) = wgt_areaave(n1(:,:,:),clat({lata:latb}),1.0,1)

end do

print(ymedia (0,:))

;-----------------------------------------
; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------
time = yyyymm_time(1979, 2019, "integer")
time@long_name = "Time"


timey = ispan(1981,2019,1)
timey@long_name = "Time"

time_lab = (/"Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago","Set","Out","Nov","Dez"/) ;label

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)
plot  = new(12,graphic)  ; xy line plots

do i=0,11
resR = True
resR@xyLineThicknessF = 4.0  ; espessura da linha
resR@xyDashPattern = 0       ; tipo de tracejado   
resR@xyLineColor = "red"     ; cor da linha
resR@tmXBLabels = time_lab

resR@tmXTOn = False ; sem eixos superior
resR@tmYROn = False ; e direito
resR@tiYAxisString = "Precipitacao (mm/dia)"

;--- plot media anual
resR@trXMinF =  1981 ; valor minimo do eixo X 
plot(i) = gsn_csm_xy (wks,timey,ymedia,resR)

end do

 ;--- Panel plots
 panelres =  True          ; Panel resources
 panelres@gsnFrame = False
 panelres@gsnPanelTop =  0.95
 
gsn_panel(wks,plot,(/4,3/),panelres)  ; now draw plots

frame(wks)
end
