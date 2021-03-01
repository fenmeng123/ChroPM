function DFC_var=CCC_DFC_Var(FC,Num_edges,TR,DFCstep,PowerThresh)
% DFC_var=CCC_DFC_SD(FC,Num_edges,Num_windows,TR,DFCstep,PowerThresh)
% compute the variability for dynamic functional connectivity (DFC-var)
% ChroPM-Chronnectome Chracteristics Calculation 
% by Kunru Song 2020.12.28 
% Input: 
% FC - a structures with a field named X, FC contains the all dynamic 
% functional connectivity across the edges, X contains the value of the 
% certain dynamic functional connectitvy across the subjects
% Num_edges - the number of brain functional connectivity(edge)
% Num_windows - the number of slice timing windows
% TR - the repetition time of fMRI scanning (TR,seconds)
% DFCstep - the number of foward step for each dynamic functional conneciviy
% PowerThresh - the threshold for filtering the potential fluctuatings noise, 
% 0.8 indicates retain 80% energy of the frequency specturm 
% 
% Output: 
% DFC_var - a subjects (row) * edges (column) matrix, every element
% indicates the DFC-sta of the dynamic functional connectivity
% Reference:
% Liu J, Liao X, Xia M, He Y. Chronnectome fingerprinting: Identifying individuals 
% and predicting higher cognitive functions using dynamic brain connectivity patterns. 
% Hum Brain Mapp. 2018;39:902-915
% 
DFC_var=zeros(1,Num_edges);
for ifc = 1:Num_edges
    [freq, amplit]=PlotFreq(FC(ifc).X', TR*DFCstep);%freq=frequency;amplit=amplitude
    mean_Freq=mean(freq,2);
    mean_Freq_sum=cumsum(mean_Freq(2:end));
    ind=min(find(mean_Freq_sum>(sum(mean_Freq(2:end)).*PowerThresh)));
    Hz=freq(ind);%The threshold point in frequency specturm
    if ifc==1
        fprintf('Cut-off frequency:%.3f\n',Hz);
    end
    DFC_var(1,ifc)=mean(amplit(2:ind,:),1);
end