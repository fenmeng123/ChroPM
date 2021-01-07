function DFC_str=CCC_DFC_Str(FC,Num_edges,Num_windows)
DFC_str=zeros(1,Num_edges);
for ifc = 1:Num_edges
    tempfc = FC(ifc).X;
    DFC_str(1,ifc)=sum(tempfc)/Num_windows;
end