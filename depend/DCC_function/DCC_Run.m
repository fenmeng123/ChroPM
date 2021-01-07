function [DCCdataset,DFCmask,ROINo,ScansNo,FCNo]=DCC_Run(SubjectFiles,SubNo)
%estimate DCC

DCCdataset=struct('ID',[],'DCCmat',[]);
for isub=1:SubNo
    fprintf('Now loading data from %s\n',SubjectFiles(isub).name)
    tmpPath=fullfile(SubjectFiles(isub).folder,SubjectFiles(isub).name);
    ROItc=load(tmpPath); %load the ROI time course
    [~,~,EXT]=fileparts(tmpPath);
    switch EXT
        case '.txt'
            ROINo=size(ROItc,2);
            ScansNo=size(ROItc,1);
            tempDCCmat=DCC(ROItc);
        case '.mat'
            ROINo=size(ROItc.ROISignals,2);
            ScansNo=size(ROItc.ROISignals,1);
            tempDCCmat=DCC(ROItc.ROISignals);
    end
    DFCmask=triu(ones(ROINo,ROINo))-diag(diag(ones(ROINo,ROINo)));
    FCNo=ROINo*(ROINo-1)/2;
    fprintf('Dynamic conditional correlation estimating...\n');
    tempDCCmat=tempDCCmat.*DFCmask;
    tempDCCmat=reshape(tempDCCmat,ROINo*ROINo,ScansNo);%reshape to FC-by-scans
    tempDCCmat(~(sum(logical(tempDCCmat),2)==ScansNo),:)=[];%delete the ROI whose time points are unequal to scans number
    DCCdataset(isub).DCCmat=tempDCCmat';%transpose to scans-by-FC
    DCCdataset(isub).ID=SubjectFiles(isub).name;
end