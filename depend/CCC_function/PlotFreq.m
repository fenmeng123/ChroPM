function [X, Y]=PlotFreq(TC, TR)

TC=detrend(TC);
PNum=size(TC,1);
Pad=2^nextpow2(PNum);

AM=2*abs(fft(TC, Pad))/PNum;
AP=(1:size(AM,1))';
AP=(AP-1)/(Pad*TR);

Cut=ceil(size(AM,1)/2)+1;
Y=AM(1:Cut,:);
X=AP(1:Cut);
%plot(X, Y);
%set(gca, 'NextPlot', 'Add');

