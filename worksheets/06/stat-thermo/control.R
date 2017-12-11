

for (i in seq(-10,0,by=0.5)){
    png_suffix=paste("dH_",i,sep="")

    run_simulation(well_depth=i,png_suffix=png_suffix,write_png=TRUE)

}
