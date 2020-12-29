function DFC_sd=CCC_DFC_SD(FC,Num_edges)
% DFC_sd=CCC_DFC_SD(FC,Num_edges)
% calculate standard deviations for dynamic functional connectivity 
% ChroPM-Chronnectome Chracteristics Calculation
% By Kunru Song 2020.12.28
% Input:
% FC - a structures with a field named X,X
DFC_sd=zeros(1,Num_edges);
for ifc = 1:Num_edges
    tempfc = FC(ifc).X;
    DFC_sd(isub,ifc)=std(tempfc);
end