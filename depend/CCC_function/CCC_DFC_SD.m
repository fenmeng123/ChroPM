function DFC_sd=CCC_DFC_SD(FC,Num_edges)
% DFC_sd=CCC_DFC_SD(FC,Num_edges) calculate standard deviations for dynamic
% functional connectivity ChroPM-Chronnectome Chracteristics Calculation By
% Kunru Song 2020.12.28 
% Input: 
% FC - a structures with a field named X, FC contains the all dynamic 
% functional connectivity across the edges, X contains the value of the 
% certain dynamic functional connectitvy across the subjects 
% Output: 
% DFC_sd - a subjects (row) * edges (column) matrix, every element
% indicates the standarad deviation of the dynamic functional connectivity
DFC_sd=zeros(1,Num_edges);
for ifc = 1:Num_edges
    tempfc = FC(ifc).X;
    DFC_sd(isub,ifc)=std(tempfc);
end