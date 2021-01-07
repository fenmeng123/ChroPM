function CCC_Run(handles)
%Main funcion for ChroPM-Chronnectome Characteristic Calculator
%Written by Kunru Song 2020.10.09
% Modified History
% add sub functions for CCC by Kunru Song 2020.12.28
clc
%-------------------------------------------------------------------------%
% get the current time
NowTime=[year(datetime) month(datetime) day(datetime) hour(datetime) minute(datetime)];
NowTime=[num2str(NowTime(1)) '_' num2str(NowTime(2)) num2str(NowTime(3)) '_' num2str(NowTime(4)) num2str(NowTime(5))];
%get dynamic characteristic flag
Cfg.FlagStr=get(handles.DFCstr_checkbox,'value');
Cfg.FlagSta=get(handles.DFCsta_checkbox,'value');
Cfg.FlagVar=get(handles.DFCvar_checkbox,'value');
Cfg.FlagSD=get(handles.DFCsd_checkbox,'value');
Cfg.FlagtGV=get(handles.tGV_checkbox,'value');
Cfg.FlagtMV=get(handles.tMV_checkbox,'value');

Cfg.VarTR=str2double(get(handles.TR_Edit,'string'));
Cfg.VarDFCstep=str2double(get(handles.Step_Edit,'string'));
Cfg.VarPowerThresh=str2double(get(handles.PowerThresh_Edit,'string'));

FlagCCC=[Cfg.FlagStr Cfg.FlagSta Cfg.FlagVar Cfg.FlagSD Cfg.FlagtGV Cfg.FlagtMV];
%get input data path
DataPath=fullfile(handles.InputPath,handles.SubList);
SubNo=length(DataPath);
% get output file prefix
Prefix=get(handles.Prefix_edit,'String');
% open diary
diary(fullfile(handles.OutputPath,['ChroPM_Log_CCC_' NowTime '.txt']))
% check CCC settings
if sum(FlagCCC)==0
    diary('off')
    error('No Chronectome characteristics need to be calculated\n')
end

for isub = 1:SubNo
    fprintf('Load Subject data: %s\n',handles.SubList{isub})
    switch handles.DataType
        case 1
            diary('off')
            error('DFC data type has not been correctly chosen.')
        case 2
            
        case {3,4}
% When handles.DataType==3, it means DynamicBC(FCM) Sliding Window When
% handles.DataType==4, it means DynamicBC(FCM) FLS. handles.DataType-2
% means using dimension 1 or dimension 2 to get the number of time windows,
% for Sliding Window(dim 1) and FLS(dim 2)
            temp = dir(fullfile(DataPath{isub},'*.mat'));%sublist index file
            DataDynamic.DFC=load(fullfile(temp.folder,temp.name));clear temp
            Num_nodes=size(DataDynamic(1).DFC.FCM.Matrix{1},1);%get the number of nodes
            Num_edges=Num_nodes*(Num_nodes-1)/2;
            Num_windows=size(DataDynamic(1).DFC.FCM.Matrix,handles.DataType-2);%get the number of sliding windows
            fprintf('Nodes:%d Edges:%d\n',Num_nodes,Num_edges);
            FC_dyn=zeros(Num_nodes,Num_nodes,Num_windows);%FC_dyn: M*M*T a three-dimention matrix
            fprintf('Reorganize dynamic FC for %s\n',handles.SubList{isub});
            for jtime = 1:Num_windows
                FC_dyn(:,:,jtime)=full(DataDynamic.DFC.FCM.Matrix{jtime});
                fprintf('.')
            end
            fprintf('\n')
    end
    if isub==1 %only for the first loop
        %generate triangle edge mask for FC_dyn
        TriEdgeMask=ones(Num_nodes,Num_nodes);
        TriEdgeMask=triu(TriEdgeMask)-diag(diag(TriEdgeMask));
        %generate FC index and save it to ouput path
        [FCx,FCy]=find(TriEdgeMask~=0);
        FC_index.ROI1=FCx;
        FC_index.ROI2=FCy;
        FC_index.No_column=[1:Num_edges]';
        FC_index=struct2table(FC_index);
    end
    %Pre-allocate memory for dynamic characteristics
    DFC_str=zeros(SubNo,Num_edges);
    DFC_sta=zeros(SubNo,Num_edges);
    DFC_var=zeros(SubNo,Num_edges);
    tGV=zeros(SubNo,Num_nodes);
    DFC_sd=zeros(SubNo,Num_edges);
    FC=struct('X',[]);
    fprintf('Reshape dynamic FC for %s\n',handles.SubList{isub});
    for ifc =1:Num_edges
        FC(ifc).X=reshape(FC_dyn(FCx(ifc),FCy(ifc),:),1,[]);
        fprintf('.')
    end
    fprintf('\n')
    %% calculate DFC-str
    %FC(ifc).X(i,:) 索引第i位被试的第ifc条动态功能链接
    if Cfg.FlagStr
        fprintf('Estimating DFC strength for %s\n',handles.SubList{isub})
        DFC_str(isub,:)=CCC_DFC_Str(FC,Num_edges,Num_windows);
    end
    %% calculate DFC-sta
    if Cfg.FlagSta
        fprintf('Estimating DFC stablility for %s\n',handles.SubList{isub})
        DFC_sta(isub,:)=CCC_DFC_Sta(FC,Num_edges,Num_windows);
    end
    
    %% calculate DFC-var
    % Exchange DFC variability code with Jin-Liu Github code
    % refer to 'tGV_find_threshold.m' 'dyn_FC_var_measurements.m'
    % By Kunru Song 2020.10.07
    if Cfg.FlagVar
        fprintf('Estimating DFC variability for %s\n',handles.SubList{isub})
        DFC_var(isub,:)=CCC_DFC_Var(FC,Num_edges,Cfg.VarTR,Cfg.VarDFCstep,Cfg.VarPowerThresh);
    end
    %% calculate node tGV
    %added by Kunru Song 2020.10.08
    if Cfg.FlagtGV
        fprintf('Estimating tGV for %s\n',handles.SubList{isub})
        tGV(isub,:)=CCC_tGV(DFC_var,Num_nodes,Num_edges,FCx,FCy,isub);
    end
    %% calculate DFC-SD
    %added by Kunru Song 2020.10.08
    if Cfg.FlagSD
        fprintf('Estimating SD for %s\n',handles.SubList{isub})
        DFC_sd(isub,:)=CCC_DFC_SD(FC,Num_edges);
    end
    %% calculate tMV
    %added by Kunru Song 2020.12.19
    if Cfg.FlagtMV
        fprintf('Estimating tMV for %s\n',handles.SubList{isub})
        for iwindow=1:size(FC_dyn,3)
            W=FC_dyn(:,:,iwindow);
            [A,~] = gretna_R2b(W, 's', 0.15);
            
            fprintf('.')
        end
    end
end%Ending for subject loop

%save results
if Cfg.FlagStr%Debug: added 'if ' 2020.10.07 by Kunru Song
    OutputFileName=[Prefix '_' 'str.mat'];
    save(fullfile(handles.OutputPath,OutputFileName),'DFC_str');
end

if Cfg.FlagSta
    OutputFileName=[Prefix '_' 'sta.mat'];
    save(fullfile(handles.OutputPath,OutputFileName),'DFC_sta');
end

if Cfg.FlagVar
    OutputFileName=[Prefix '_' 'var.mat'];
    save(fullfile(handles.OutputPath,OutputFileName),'DFC_var');
end

if Cfg.FlagSD
    OutputFileName=[Prefix '_' 'sd.mat'];
    save(fullfile(handles.OutputPath,OutputFileName),'DFC_sd');
end

if Cfg.FlagtGV
    OutputFileName=[Prefix '_' 'tGV.mat'];
    save(fullfile(handles.OutputPath,OutputFileName),'tGV');
end

if Cfg.FlagtMV
    OutputFileName=[Prefix '_' 'tMV.mat'];
    save(fullfile(handles.OutputPath,OutputFileName),'tMV');
end

%save sublist index file
save(fullfile(handles.OutputPath,['SUBindex_' NowTime '.mat']),'DataPath');
fprintf('sublist index file has been saved to %s\n',handles.OutputPath)
save(fullfile(handles.OutputPath,['FCindex_' NowTime '.mat']),'FC_index');
fprintf('FC index file has been saved to %s\n',handles.OutputPath)

fprintf('\n\nCongratulations!CCC workflow has been finished:)\n\n')
diary('off')
save(fullfile(handles.OutputPath,['CCC_AutoSave' NowTime '.mat']),'Cfg')