load "/mnt/c/Users/Breno/Documents/INPE/dados/shapefile_utils.ncl" 

begin

;abrindo o arquivo shapefile e verificando o codigo do estado
dir = "/mnt/c/users/breno/documents/inpe/dados/"
f = addfile(dir + "regioes_hidrograficas.shp", "r") 
sname = dir+"regioes_hidrograficas.shp"
print_shapefile_info(sname)
var = f->rhi_nm(:)
print(var)

end
