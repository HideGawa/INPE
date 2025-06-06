;-------------------------------------------------------
; Mask precipitation
;-------------------------------------------------------
load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl"
begin

;-------------------------------------------------------
; User specifications
;-------------------------------------------------------

src = "pr_CESM2_ssp370"
vars = "pr"   
na = 12 ; number of areas
dirc = "/mnt/c/users/Breno/Documents/INPE/Atividade8.2/CESM2/ssp370/"
dir  = "/mnt/c/users/breno/documents/inpe/dados/"
sname = dir+"Regioes_Hidrograficas.shp"

; informations of the shapefile
;   f = addfile(sname,"r")
;   print_shapefile_info(sname)
;   vs = f->OBJECTID
;   print(vs)

;-------------------------------------------------------
; Reading NC
;-------------------------------------------------------
fc = addfile(dirc+src+"_1981-2100.nc","r")
vc = fc->$vars$   
lat = fc->lat
vc = lonFlip(vc)
;vc = vc*86400
print(vc)

;-------------------------------------------------------
; Estimate number of years
;-------------------------------------------------------
qdims = dimsizes(vc)
printVarSummary(qdims)
tdim = qdims(0)
nyears = tdim/12

;-------------------------------------------------------
; Calcular anomalia mensal
;-------------------------------------------------------
clim = clmMonTLL(vc(0:359,:,:))
anom = calcMonAnomTLL(vc,clim)

;-------------------------------------------------------
; calculate média anual
;-------------------------------------------------------
yanom = month_to_annual(anom,1)

;-------------------------------------------------------
; weights for the area mean
;-------------------------------------------------------
rad  = 4.0*atan(1.0)/180
clat = cos(lat*rad) 
clat!0 = "lat"
clat&lat = lat

;-------------------------------------------------------
; Restrict lat, lon
;-------------------------------------------------------
f1 = yanom(:,:,:)

;------------------------------------------------------
; Masking
;------------------------------------------------------
var = new((/na,nyears/),float) ; (areas, years)

; masking options
  opt             = True
  opt@debug       = True
  opt@keep        = True    ; keep data for brazil
  opt@return_mask = True
  objid = (/1,2,3,4,5,6,7,8,9,10,11,12/)


; masking only works for 2D
do i=0,na-1
   opt@shape_var   = "rhi_cd"    
   opt@shape_names := (/objid(i)/)     ; ID for sub-basin
   m1 := shapefile_mask_data(f1(0,:,:),sname,opt) ;2Dmask
   copy_VarMeta(f1(0,:,:),m1)            ; used for plots
   m3 := conform_dims(dimsizes(f1),m1,(/1,2/)) ; 3Dmask
   n1 := mask(f1,m3,1)
   var(i,:) = wgt_areaave(n1(:,:,:),clat(:),1.0,0)  ; area mean
end do

printVarSummary(var)

   timec = ispan(1981,2100,1) ; ano inicial e final 
   var!0 = "area"
   var!1 = "time"
   var&time = timec
   var&area = objid

;---Write new mask to file
   print("Creating the mask file...")
   mask_fname = "teste.nc"
   system("rm -f " + mask_fname)
   fout = addfile(mask_fname,"c")
   fout->pr = var(:,:)


end




