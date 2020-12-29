function DFC_sta=CCC_DFC_Sta(FC,Num_edges)
DFC_sta=zeros(1,Num_edges);
for ifc = 1:Num_edges
    tempfc = FC(ifc).X;
    DFC_sta(1,ifc)=1-(1/(Num_windows-1))*sum(abs(tempfc(2:Num_windows)-tempfc(1:Num_windows-1))./2);
end