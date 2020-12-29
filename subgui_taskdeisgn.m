function varargout = subgui_taskdeisgn(varargin)
% SUBGUI_TASKDEISGN MATLAB code for subgui_taskdeisgn.fig
%      SUBGUI_TASKDEISGN, by itself, creates a new SUBGUI_TASKDEISGN or raises the existing
%      singleton*.
%
%      H = SUBGUI_TASKDEISGN returns the handle to a new SUBGUI_TASKDEISGN or the handle to
%      the existing singleton*.
%
%      SUBGUI_TASKDEISGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBGUI_TASKDEISGN.M with the given input arguments.
%
%      SUBGUI_TASKDEISGN('Property','Value',...) creates a new SUBGUI_TASKDEISGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before subgui_taskdeisgn_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to subgui_taskdeisgn_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help subgui_taskdeisgn

% Last Modified by GUIDE v2.5 12-Nov-2020 19:55:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subgui_taskdeisgn_OpeningFcn, ...
                   'gui_OutputFcn',  @subgui_taskdeisgn_OutputFcn, ...
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


% --- Executes just before subgui_taskdeisgn is made visible.
function subgui_taskdeisgn_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to subgui_taskdeisgn (see VARARGIN)

% Choose default command line output for subgui_taskdeisgn
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);


% UIWAIT makes subgui_taskdeisgn wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = subgui_taskdeisgn_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(handles)
    varargout{1}=[];
else
    varargout{1} = handles.output;
    delete(handles.figure1);
end

% --- Executes on button press in AddCon_pushbutton.
function AddCon_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddCon_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldData = get(handles.TaskDesign_uitable,'Data'); %保存原来的数据
prompt ={'condition name:','onset time(secs):','duration time(secs):'}; %对话框内容提示
title = 'new con';    %对话框标题
lines = [1 30;1 40;1 40]; %设置输入框行数
tab = inputdlg(prompt,title,lines);  %对话框设置
tab=reshape(tab,1,3);
newData = [oldData;tab];  %新的数据源
set(handles.TaskDesign_uitable,'Data',newData);  %显示到表格中

% --- Executes on button press in Accept_pushbutton.
function Accept_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Accept_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get TR and nscans
TR=str2double(get(handles.TR_edit,'string'));
nscans=str2double(get(handles.nscan_edit,'string'));
if isnan(TR)||isnan(nscans)
    error('TR or the number of scans have not been specified!');
end
fprintf('TR=%ds\n',TR)
fprintf('nscans=%d\n',nscans);
fprintf('Loading task design data......\n')
TaskDesignData=get(handles.TaskDesign_uitable,'Data');
DataRowNo=size(TaskDesignData,1);
DataColumnNo=size(TaskDesignData,2);
if DataColumnNo~=3
    error('incomplete design matrix data!')
end
%find the non-empty cell elements
DataFilter=zeros(DataRowNo,DataColumnNo);
for irow=1:DataRowNo
    for icol=1:DataColumnNo
        DataFilter(irow,icol)=~isempty(TaskDesignData{irow,icol}) ;
    end
end
TaskDesignData=reshape(TaskDesignData(logical(DataFilter)),[],3);
%get the task design matrix
ConNo=size(TaskDesignData,1);
ConName=TaskDesignData(:,1);%ConName is a cell
TaskDesignData(:,2)=strtrim(TaskDesignData(:,2));%de blank
for icon=1:ConNo
    ConOnsetTime(icon,:)=str2num(TaskDesignData{icon,2});%change to number(double mat)
    ConDuraTime(icon,:)=str2num(TaskDesignData{icon,3});
end
output.ConNo=ConNo;
output.ConName=ConName;
output.ConOnsetTime=ConOnsetTime;
output.ConDuraTime=ConDuraTime;
output.TR=TR;
output.nscans=nscans;
handles.output=output;
guidata(hObject,handles);
uiresume(handles.figure1);

function TR_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TR_edit as text
%        str2double(get(hObject,'String')) returns contents of TR_edit as a double


% --- Executes during object creation, after setting all properties.
function TR_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nscan_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nscan_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nscan_edit as text
%        str2double(get(hObject,'String')) returns contents of nscan_edit as a double


% --- Executes during object creation, after setting all properties.
function nscan_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nscan_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
