function [DCCdataset,DFCmask,ROINo,ScansNo,FCNo]=DCC_Run(SubjectFiles,DCCoutPath,SubNo)
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
            DCCmat=DCC(ROItc);
        case '.mat'
            ROINo=size(ROItc.ROISignals,2);
            ScansNo=size(ROItc.ROISignals,1);
            DCCmat=DCC(ROItc.ROISignals);
    end
    fprintf('Creating DFC mask...\n')
    DFCmask=triu(ones(ROINo,ROINo))-diag(diag(ones(ROINo,ROINo)));
    FCNo=ROINo*(ROINo-1)/2;
    fprintf('Dynamic conditional correlation estimating...\n');
    DCCmat=DCCmat.*DFCmask;
    DCCmat=reshape(DCCmat,ROINo*ROINo,ScansNo);%reshape to FC-by-scans
    DCCmat(~(sum(logical(DCCmat),2)==ScansNo),:)=[];%delete the ROI whose time points are unequal to scans number
    DCCmat=DCCmat';
    DCCdataset(isub).DCCmat=DCCmat;%transpose to scans-by-FC
    DCCdataset(isub).ID=SubjectFiles(isub).name;
    save([DCCoutPath filesep 'DCC_' DCCdataset(isub).ID '.mat'],'DCCmat');
end