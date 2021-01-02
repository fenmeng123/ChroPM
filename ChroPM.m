function varargout = ChroPM(varargin)
% CHROPM MATLAB code for ChroPM.fig
%      CHROPM, by itself, creates a new CHROPM or raises the existing
%      singleton*.
%
%      H = CHROPM returns the handle to a new CHROPM or the handle to
%      the existing singleton*.
%
%      CHROPM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHROPM.M with the given input arguments.
%
%      CHROPM('Property','Value',...) creates a new CHROPM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChroPM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChroPM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChroPM

% Last Modified by GUIDE v2.5 28-Dec-2020 19:08:23
% Modificated History
% Chronectome Predictive Modeling toolbox developed by Kunru Song 2020.8.24
% Update variability calculator with Jin-Liu's code by Kunru Song 2020.10.07
% DCC calculator developed by Kunru Song 2020.10.07
% Automatically generate FC index file by Kunru Song 2020.10.08
% Add predictive modeling panel by Kunru Song 2020.10.30
% Add autosave parameter function for CCC by Kunru Song 2020.12.19
% Optimization for CCC workflow and subfunction by Kunru Song 2020.12.29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ChroPM_OpeningFcn, ...
    'gui_OutputFcn',  @ChroPM_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ChroPM is made visible.
function ChroPM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChroPM (see VARARGIN)

% Choose default command line output for ChroPM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChroPM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ChroPM_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_CCChelp.
function pushbutton_CCChelp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_CCChelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'等我有空再写这个。。',...
    '用之前记得先添加路径!',...
    'mat files数据类型还没写,V0.2仅支持DynamicBC的输出文件'},...
    'Tips',...
    'CCC')


% --- Executes on selection change in SubjectListBox.
function SubjectListBox_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SubjectListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SubjectListBox


% --- Executes during object creation, after setting all properties.
function SubjectListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubjectListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DataInputPath_Callback(hObject, eventdata, handles)
% hObject    handle to DataInputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataInputPath as text
%        str2double(get(hObject,'String')) returns contents of DataInputPath as a double


% --- Executes during object creation, after setting all properties.
function DataInputPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataInputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetInputButton.
function SetInputButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetInputButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputPath=uigetdir(pwd,'select your data input path');
FileFilter=inputdlg('Files filter:','',[1 25],{'*ZhangJT*'});
SubjectFolderList=dir(fullfile(InputPath,cell2mat(FileFilter)));
SubList={SubjectFolderList.name};
set(handles.DataInputPath,'String',InputPath);
set(handles.SubjectListBox,'String',SubList);
handles.SubList=SubList;
handles.InputPath=InputPath;
guidata(hObject,handles)



function DataOutputPath_Callback(hObject, eventdata, handles)
% hObject    handle to DataOutputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataOutputPath as text
%        str2double(get(hObject,'String')) returns contents of DataOutputPath as a double


% --- Executes during object creation, after setting all properties.
function DataOutputPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataOutputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetOutputPath.
function SetOutputPath_Callback(hObject, eventdata, handles)
% hObject    handle to SetOutputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputPath=uigetdir(pwd,'Set your data output path');
if ~exist(OutputPath,'dir')
    mkdir(OutputPath);
end
set(handles.DataOutputPath,'String',OutputPath);
handles.OutputPath=OutputPath;
guidata(hObject,handles);


% --- Executes on button press in DFCstr_checkbox.
function DFCstr_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to DFCstr_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DFCstr_checkbox


% --- Executes on button press in DFCsta_checkbox.
function DFCsta_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to DFCsta_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DFCsta_checkbox


% --- Executes on button press in DFCvar_checkbox.
function DFCvar_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to DFCvar_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DFCvar_checkbox
if get(handles.DFCvar_checkbox,'value')
    set(handles.tGV_checkbox,'enable','on')
    set(handles.TR_Edit,'enable','on')
    set(handles.Step_Edit,'enable','on')
    set(handles.PowerThresh_Edit,'enable','on')
else
    set(handles.tGV_checkbox,'enable','off')
    set(handles.TR_Edit,'enable','off')
    set(handles.Step_Edit,'enable','off')
    set(handles.PowerThresh_Edit,'enable','off')
end

% --- Executes on button press in CCCrun_button.
function CCCrun_button_Callback(hObject, eventdata, handles)
% hObject    handle to CCCrun_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CCC_Run(handles)

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in DataTypePopupmenu.
function DataTypePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to DataTypePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DataTypePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataTypePopupmenu
contents = cellstr(get(hObject,'String'));
DataType = get(hObject,'Value');
switch DataType
    case 2
        set(handles.VarNameEdit,'enable','on')
        set(handles.VarNameEdit,'String','input your variable name')
        fprintf('The DFC data type has been set to %s\n',contents{DataType})
    case 3
        set(handles.VarNameEdit,'String','FCM')
        set(handles.VarNameEdit,'enable','off')
        fprintf('The DFC data type has been set to %s\n',contents{DataType})
    case 4
        set(handles.VarNameEdit,'String','FCM')
        set(handles.VarNameEdit,'enable','off')
        fprintf('The DFC data type has been set to %s\n',contents{DataType})
    otherwise
        fprintf('Please select your data type\n');
end
handles.DataType=DataType;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function DataTypePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataTypePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VarNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to VarNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VarNameEdit as text
%        str2double(get(hObject,'String')) returns contents of VarNameEdit as a double


% --- Executes during object creation, after setting all properties.
function VarNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VarNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TR_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to TR_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TR_Edit as text
%        str2double(get(hObject,'String')) returns contents of TR_Edit as a double
fprintf(['TR has been set to ' get(handles.TR_Edit,'string') 's\n'])


% --- Executes during object creation, after setting all properties.
function TR_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TR_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Step_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Step_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Step_Edit as text
%        str2double(get(hObject,'String')) returns contents of Step_Edit as a double
fprintf(['DFC step has been set to ' get(handles.Step_Edit,'string') ' time point\n'])

% --- Executes during object creation, after setting all properties.
function Step_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Step_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PowerThresh_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PowerThresh_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PowerThresh_Edit as text
%        str2double(get(hObject,'String')) returns contents of PowerThresh_Edit as a double
fprintf(['Power threshold has been set to ' get(handles.PowerThresh_Edit,'string') '\n'])

% --- Executes during object creation, after setting all properties.
function PowerThresh_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PowerThresh_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DFCsd_checkbox.
function DFCsd_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to DFCsd_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DFCsd_checkbox


% --- Executes on button press in tGV_checkbox.
function tGV_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to tGV_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tGV_checkbox


% --- Executes on button press in pushbutton_DCChelp.
function pushbutton_DCChelp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DCChelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'This module could apply the dynamic conditional correlation to estimate dynamic funcional connectivity',...
    ' ',...
    'Ref:'},...
    'Tips',...
    'help')


% --- Executes on button press in tMV_checkbox.
function tMV_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to tMV_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tMV_checkbox
fprintf('tMV has not been finished in V0.3\n')


% --- Executes on button press in PM_help.
function PM_help_Callback(hObject, eventdata, handles)
% hObject    handle to PM_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PMcpm_pushbutton.
function PMcpm_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PMcpm_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('this function has not been finished in V0.3!')

% --- Executes on button press in DCCselect_pushbutton.
function DCCselect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DCCselect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputPath=uigetdir(pwd,'select your data input path');
FileFilter=inputdlg('Files filter:','',[1 25],{'*ZhangJT*.mat'});
SubjectFolderList=dir(fullfile(InputPath,cell2mat(FileFilter)));
SubList={SubjectFolderList.name};
set(handles.DCCinput_edit,'String',InputPath);
set(handles.DCCsub_listbox,'String',SubList);
handles.DCCsublist=SubjectFolderList;
handles.DCCinput=InputPath;
guidata(hObject,handles)


function DCCinput_edit_Callback(hObject, eventdata, handles)
% hObject    handle to DCCinput_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DCCinput_edit as text
%        str2double(get(hObject,'String')) returns contents of DCCinput_edit as a double


% --- Executes during object creation, after setting all properties.
function DCCinput_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCCinput_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DCCsub_listbox.
function DCCsub_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to DCCsub_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DCCsub_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DCCsub_listbox


% --- Executes during object creation, after setting all properties.
function DCCsub_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCCsub_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunDCC_pushbutton.
function RunDCC_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RunDCC_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ROINo=str2double(cell2mat(inputdlg('the number of ROI:','',[1 25],{'268'})));
SubjectFiles=handles.DCCsublist; %get path of ROI signals files
SubNo=length(SubjectFiles);
fprintf('Creating DFC mask...\n')
DFCmask=triu(ones(ROINo,ROINo))-diag(diag(ones(ROINo,ROINo)));%generate DFC mask matrix(upper triangular matrix without diag)
ScansNo=str2double(cell2mat(inputdlg('the number of scans:','',[1 25],{'240'})));
FCNo=ROINo*(ROINo-1)/2;
DCCdataset=struct('ID',[],'DCCmat',[]);
%dipslay basic infomation
set(handles.TaskSubNo_text,'string',['Subjects:' num2str(SubNo)])
set(handles.TaskROINo_text,'string',['ROI:' num2str(ROINo)])
set(handles.TaskScansNo_text,'string',['Scans:' num2str(ScansNo)])
%estimate DCC
for i=1:SubNo
    fprintf('Now loading data from %s\n',SubjectFiles(i).name)
    ROItc=load(fullfile(SubjectFiles(i).folder,SubjectFiles(i).name)); %load the ROI time course
    fprintf('Dynamic conditional correlation estimating...\n');
    tempDCCmat=DCC(ROItc.ROISignals);
    tempDCCmat=tempDCCmat.*DFCmask;
    tempDCCmat=reshape(tempDCCmat,ROINo*ROINo,ScansNo);%reshape to FC-by-scans
    tempDCCmat(~(sum(logical(tempDCCmat),2)==ScansNo),:)=[];%delete the ROI whose time points are unequal to scans number
    DCCdataset(i).DCCmat=tempDCCmat';%transpose to scans-by-FC
    DCCdataset(i).ID=SubjectFiles(i).name;
end
%generate DFC index table for subsequent data processing
[row_DFCindex,col_DFCindex]=find(DFCmask);
FC_ColumnNo=1:FCNo;FC_ColumnNo=FC_ColumnNo';
DFCindex=table(FC_ColumnNo,row_DFCindex,col_DFCindex);%get DFC index table;
save(handles.DCCoutPath,'DCCdataset')
save(handles.DCCoutPath,'DFCindex')
set(handles.TaskDFCdatapath_edit,'string',OutPath)
handles.DCCdataset=DCCdataset;
guidata(hObject,handles)

% --- Executes on button press in TaskDesign_pushbutton.
function TaskDesign_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to TaskDesign_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% spm_jobman('interactive','','spm.stats.fmri_spec')%open spm batch gui 

%check spm path
if isempty(spm('dir'))
   error('SPM directory is required!') 
end
fprintf('SPM version:\t%s\n',spm('version'))
%select output path
TaskDesignOutPath=uigetdir(pwd,'select your task design matrix file output path');
set(handles.TaskDesignFilePath_edit,'String',TaskDesignOutPath);
%load spm defaults mat file
SPMmatpath=which('ChroPM_defaults_HRF.mat');
load(SPMmatpath)
%set time unit and name(default)
SPM.xBF.UNITS='secs';
SPM.xBF.name='hrf';
%open task design matrix subgui
TaskDesign = subgui_taskdeisgn();
SPM.xY.RT=TaskDesign.TR;
SPM.nscan=TaskDesign.nscans;
%condition settings
for icon=1:TaskDesign.ConNo
    SPM.Sess.U(icon).name=TaskDesign.ConName(icon);
    SPM.Sess.U(icon).ons=TaskDesign.ConOnsetTime(icon,:);
    SPM.Sess.U(icon).dur=TaskDesign.ConDuraTime(icon,:);
    SPM.Sess.U(icon).orth=1;
    SPM.Sess.U(icon).P=struct('name','none','h',0);
end
%execute default settings
s=1;%Session
%-Number of scans for this session
k = SPM.nscan(s);
%-Construct Design matrix {X}
%-Microtime onset and microtime resolution
try
    fMRI_T     = SPM.xBF.T;
    fMRI_T0    = SPM.xBF.T0;
catch
    fMRI_T     = spm_get_defaults('stats.fmri.t');
    fMRI_T0    = spm_get_defaults('stats.fmri.t0');
    SPM.xBF.T  = fMRI_T;
    SPM.xBF.T0 = fMRI_T0;
end
%-Time units, dt = time bin {secs}
SPM.xBF.dt     = SPM.xY.RT/SPM.xBF.T;
%-Get basis functions
SPM.xBF        = spm_get_bf(SPM.xBF);
%-Get session specific design parameters
Xx    = [];
Xb    = [];
Xname = {};
Bname = {};
%-Get inputs, neuronal causes or stimulus functions U
U = spm_get_ons(SPM,s);
%-Convolve stimulus functions with basis functions
[X,Xn,Fc] = spm_Volterra(U, SPM.xBF.bf, SPM.xBF.Volterra);
%-Resample regressors at acquisition times (32 bin offset)
if ~isempty(X)
    X = X((0:(k - 1))*fMRI_T + fMRI_T0 + 32,:);
end
%set neative value to zero
X(X<0)=0;
%save design matrix datafile
WeightFunc.design=X;
WeightFunc.condition=SPM.Sess.U;
save(fullfile(TaskDesignOutPath,'SPM.mat'),'SPM');
save(fullfile(TaskDesignOutPath,'DesignMatrixFunc.mat'),'WeightFunc');
handles.TaskDesignMatrixFile=fullfile(TaskDesignOutPath,'DesignMatrixFunc.mat');
guidata(hObject,handles)


% --- Executes on button press in WeightFunc_pushbutton.
function WeightFunc_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to WeightFunc_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function TaskDesignFilePath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TaskDesignFilePath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TaskDesignFilePath_edit as text
%        str2double(get(hObject,'String')) returns contents of TaskDesignFilePath_edit as a double


% --- Executes during object creation, after setting all properties.
function TaskDesignFilePath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TaskDesignFilePath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TaskDFCselect_pushbutton.
function TaskDFCselect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to TaskDFCselect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputPath=uigetdir(pwd,'select your DFC data files directory');
FileFilter=inputdlg('Files filter:','',[1 25],{'*ZhangJT*.mat'});
SubjectFolderList=dir(fullfile(InputPath,cell2mat(FileFilter)));
SubList={SubjectFolderList.name};
set(handles.TaskDFCdatapath_edit,'String',InputPath);
set(handles.DCCsub_listbox,'String',SubList);
handles.DFCsublist=SubjectFolderList;
handles.DFCinput=InputPath;
guidata(hObject,handles)


function TaskDFCdatapath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TaskDFCdatapath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TaskDFCdatapath_edit as text
%        str2double(get(hObject,'String')) returns contents of TaskDFCdatapath_edit as a double


% --- Executes during object creation, after setting all properties.
function TaskDFCdatapath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TaskDFCdatapath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PMdatastruc_pushbutton.
function PMdatastruc_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PMdatastruc_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('this function has not been finished in V0.3!\n')

% --- Executes on button press in PMfeatureselect_pushbutton.
function PMfeatureselect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PMfeatureselect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('this function has not been finished in V0.3!\n')



function Prefix_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Prefix_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Prefix_edit as text
%        str2double(get(hObject,'String')) returns contents of Prefix_edit as a double


% --- Executes during object creation, after setting all properties.
function Prefix_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Prefix_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DCCoutput_edit_Callback(hObject, eventdata, handles)
% hObject    handle to DCCoutput_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DCCoutput_edit as text
%        str2double(get(hObject,'String')) returns contents of DCCoutput_edit as a double


% --- Executes during object creation, after setting all properties.
function DCCoutput_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCCoutput_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DCCset_pushbutton.
function DCCset_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DCCset_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DCCoutPath=uigetdir(pwd,'set your DCC estimation results output path');
set(handles.DCCoutput_edit,'String',DCCoutPath);
handles.DCCoutPath=DCCoutPath;
guidata(hObject,handles)
