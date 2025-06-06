load "/mnt/c/users/breno/documents/inpe/dados/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/breno/documents/inpe/dados/text.ncl"

begin

cod = (/"12","3","9","4","10","2","5","6","8","11","1","7"/)

minlat = -45
maxlat = 15
minlon = -85
maxlon = -30

dir = "/mnt/c/users/breno/documents/inpe/dados/" ;local mascara
;dirc = "/mnt/c/users/arthur/documents/ic/4.3.2/";local chirps pequeno
dird = "/mnt/c/users/breno/documents/inpe/dados/" ;local chirps grande
sname = dir+"regioes_hidrograficas.shp"


print_shapefile_info(sname)

;fc = addfile(dirc+"novochirps2.nc","r") ;chirps 256mb 
fd = addfile (dird+"gpcc.nc","r") ;chirps 6gb


media = new((/12,12/),float) 

;clm = fc->precip(:,:,:)
tot = fd->precip(:,{minlat:maxlat},:)

;lon = fd->lon
;lonFlip(lon)

;-----------------------Climatologia-------------------------------------



clm = clmMonTLL (tot(0:359,:,:)) ; 
print("clm")
;va := month_to_annual(clm,0) ;[total,climatologia]
print("va")
var1 := lonFlip(clm)              ; -180 to 180
;f1 := va(:,{minlat:maxlat},{minlon:maxlon},:) ;- restrict range  
printVarSummary(var1)




;------------------------------------------------------------------------

lat = fd->lat      
rad = 4.0*atan(1.0)/180
clat = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

opt             = True
opt@return_mask = True
opt@debug       = True
opt@shape_var   = "rhi_cd"  ; variavel do shapefile

do j=0,11
	opt@shape_names = cod(j)     
	prec_mask      := shapefile_mask_data(var1(0,:,:),sname,opt)
	copy_VarMeta(var1(0,:,:),prec_mask)
	m3 := conform_dims(dimsizes(var1),prec_mask,(/1,2/))  ; 3Dmask 
	;printVarSummary(m3)
	n1 :=  mask(var1,m3,1) 
	printVarSummary(n1)
	media(j,:) = wgt_areaave(n1(:,:,:),clat({minlat:maxlat}),1.0,0) 
	printVarSummary(media)
	print("media")
end do

media!0 = "area"
media!1 = "time"
media&time = clm&month

;---Write new mask to file

print("Creating the mask file...")
mask_fname = "prec-clim.nc"
system("rm -f " + mask_fname)
fout = addfile(mask_fname,"c")
fout->pr = media(:,:)

end

