function DFC_sd=CCC_DFC_SD(FC,Num_edges)
DFC_sd=zeros(1,Num_edges);
for ifc = 1:Num_edges
    tempfc = FC(ifc).X;
    DFC_sd(isub,ifc)=std(tempfc);
end