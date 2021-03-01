function DFC_str=CCC_DFC_Str(FC,Num_edges,Num_windows)
% DFC_str=CCC_DFC_SD(FC,Num_edges,Num_windows) 
% compute the strength for dynamic % functional connectivity (DFC-str)
% ChroPM-Chronnectome Chracteristics Calculation 
% by Kunru Song 2020.12.28 
% Input: 
% FC - a structures with a field named X, FC contains the all dynamic 
% functional connectivity across the edges, X contains the value of the 
% certain dynamic functional connectitvy across the subjects
% Num_edges - the number of brain functional connectivity(edge)
% Num_windows - the number of slice timing windows
% Output: 
% DFC_str - a subjects (row) * edges (column) matrix, every element
% indicates the DFC-str of the dynamic functional connectivity
% Reference:
% Liu J, Liao X, Xia M, He Y. Chronnectome fingerprinting: Identifying individuals 
% and predicting higher cognitive functions using dynamic brain connectivity patterns. 
% Hum Brain Mapp. 2018;39:902-915
% 
DFC_str=zeros(1,Num_edges);
for ifc = 1:Num_edges
    tempfc = FC(ifc).X;
    DFC_str(1,ifc)=sum(tempfc)/Num_windows;
end