function DFC_var=CCC_DFC_Var(FC,Num_edges,TR,DFCstep,PowerThresh)
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