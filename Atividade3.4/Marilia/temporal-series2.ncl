load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"

;-------------------------------------------------
; Plot serie temporal de precipitacao
;-------------------------------------------------
begin

;-------------------------------------------------
; User specifications
;-------------------------------------------------
; nao e necessario usar mais essas definicoes
;lata = -90  ; define lat-lon
;latb = 90   ; para calculo
;lona = -180    ; das medias
;lonb = 180  ; espaciais

wksName = "temporal-series-historical"         ; nome da figura
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
reg = (/"Uruguai","Atl"+acirc+"ntico Nordeste Ocidental","Parna"+iacute+"ba","Atl"+acirc+"ntico Nordeste Oriental","S"+atilde+"o Francisco","Atl"+acirc+"ntico Leste","Atl"+acirc+"ntico Sudeste","Atl"+acirc+"ntico Sul","Paran"+iacute+"","Tocantins-Araguaia","Amaz"+ocirc+"nica","Paraguai"/)

;--- Ler arquivo e variavel
; GPCC 1x1 t=468, 39 anos, 
; lat=-89.5 89.5 lon=0.5 359.5
dirm = "/mnt/c/users/breno/documents/inpe/dados/"
fm = addfile(dirm+"historical4.nc","r")
vm = fm->pr
vm := lonFlip(vm) ; p/ converter lon p/ -180 180
printVarSummary(vm)

;--- Media anual
yclim = month_to_annual(vm,0)
printVarSummary(yclim)

;--- para a media ponderada
lat = fm->lat      
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

;--- Matriz p/ guardar medias anuais p/ cada area
ymedia = new((/12,39/),float) ; n areas, anos

printVarSummary(ymedia)

;---Comandos para salvar apenas os dados sobre a bacia, funciona para apenas um tempo
dims = dimsizes(yclim) ; retorna as dimensoes da variavel yclim

opt             = True ; opcoes p/ o shapefile
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "rhi_cd"  ; variavel do shapefile

printVarSummary(ymedia)
	 
do j=0,11
	opt@shape_names = cod(j)     ; codigo da região - (0) colocar (j) quando começar a repetição
	prec_mask      := shapefile_mask_data(yclim(0,:,:),sname,opt)
	copy_VarMeta(yclim(0,:,:),prec_mask)
	m3 := conform_dims(dimsizes(yclim),prec_mask,(/1,2/))  ; 3Dmask
	n1 :=  mask(yclim,m3,1); (":=" força sobreescrever a variavel)

;--- media espacial ponderada e media anual
ymedia(j,:) = wgt_areaave(n1(:,:,:),clat,1.0,0) ; wgt_area_smooth(field,wgt,opt) opt=0 nao inclui dados faltantes

end do

;print(ymedia (0,:))

printVarSummary(ymedia)

;-----------------------------------------
; Time dimension
; cria uma matriz para o tempo (ano e mes)
;------------------------------------------
timey = ispan(1981,2019,1)
timey@long_name = "Time"

;-------------------------------------------------
; Plot
;--------------------------------------------------
wks = gsn_open_wks(wks_type,wksName)
plot  = new(12,graphic)  ; xy line plots

resR = True

resR@gsnDraw = False ; nao desenhar ainda 
resR@gsnFrame = False ; false p/ que apenas 1 figura seja gerada

resR@xyLineThicknessF = 4.0  ; espessura da linha
resR@xyDashPattern = 0       ; tipo de tracejado   
resR@xyLineColor = "red"     ; cor da linha
resR@tmXBLabels = ispan(1981,2019,1)

resR@tmXTOn = False ; sem eixos superior
resR@tmYROn = False ; e direito
resR@tiYAxisString = "Precipitacao (mm/dia)"
resR@trXMinF =  1981 ; valor minimo do eixo X 

;--- plot media anual
do i=0,11
	resR@tiMainString  = reg(i)	
	plot(i) = gsn_csm_xy (wks,timey,ymedia(i,:),resR)
end do

;--- Panel plots
panelres =  True          ; Panel resources
panelres@gsnFrame = False
panelres@gsnPanelTop =  0.95
 
gsn_panel(wks,plot,(/4,3/),panelres)  ; now draw plots

frame(wks)
end
