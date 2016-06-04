function varargout = VisualEEG(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VisualEEG_OpeningFcn, ...
                   'gui_OutputFcn',  @VisualEEG_OutputFcn, ...
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


%% Init Home
function VisualEEG_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VisualEEG (see VARARGIN)

handles.output = hObject;

% Appdata initialization
handles.time=[];
handles.EEG=[];
handles.win=[];
handles.ch=1;
handles.win_loc=[];
% handles.yrange=[];

% Update handles structure
guidata(hObject, handles);

% clear 2 views
set(handles.Global_View,'XTick',[]);
set(handles.Global_View,'YTick',[]);
set(handles.Sub_View,'XTick',[]);
set(handles.Sub_View,'YTick',[]);

%% Output Function
function varargout=VisualEEG_OutputFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VisualEEG (see VARARGIN)

varargout{1} = handles.output;


%% Callback for Global_View_Selection (win_loc)
function Global_View_Selection_Callback(hObject, eventdata, handles)
% hObject    handle to Global_View_Selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.EEG)
    win_loc=floor(get(hObject,'value'));
    win_len=handles.win;
    if win_loc>get(hObject,'max');
        win_loc=get(hObject,'max');
    elseif win_loc<get(hObject,'min')
        win_loc=get(hObject,'min');
    end
    set(hObject,'value',win_loc);
    handles.win_loc=win_loc;
    PlotEEG(hObject,handles);
    guidata(hObject,handles);
end


%% Create Function for Global_View_Selection
function Global_View_Selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Global_View_Selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Callback Function for ChannelSelection (ch)
function ChannelSelection_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.EEG)
    ch=floor(get(hObject,'value'));
    handles.ch=ch;
    init_all_control(hObject,handles);
    PlotEEG(hObject,handles);
    guidata(hObject,handles);
end


%% Create Function for ChannelSelection
function ChannelSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Callback for LoadDataButton
function LoadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get EEG data
[Filename,Filepath]=uigetfile('*.mat',...
                                  'Select Matlab Data',...
                                  'MultiSelect','off');

error=0;
datafile=[Filepath Filename];
if Filename~=0
    if exist(datafile)
        [~,~,fileextension]=fileparts(datafile);
        if strcmp(fileextension,'.mat')
            try
                handles.EEG=load(datafile,'y');
                handles.EEG=handles.EEG.y;
                handles.time=handles.EEG(1,:); % time
                handles.EEG=handles.EEG(2:end,:); % EEG
                handles.ch=1; % channel
                handles.win_loc=1; % window location
                EEG_len=length(handles.time); 
                handles.win=floor(EEG_len/2); % window length
%                 handles.yrange=[min(handles.EEG(handles.ch,1:end)) max(handles.EEG(handles.ch,1:end))];
                if EEG_len<10
                    errordlg('Length of EEG must be larger than 10.','File Error');
                    error=1;
                else
                    init_all_control(hObject,handles);
                end
            catch err
                errordlg('"mat" file must contain "y" for EEG signals','File Error');
                error=1;
            end
        else
            errordlg('Please select a "mat" file','File Error');
            error=1;
        end
    else
        errordlg('Please select an existed file','File Error');
        error=1;
    end
else
    errordlg('Please select one data file','File Error');
    error=1;
end

if ~error
    PlotEEG(hObject,handles);
end

% store data
guidata(hObject,handles);


%% Init Control Pannels
function init_all_control(hObject,handles)

EEG_len=length(handles.time);

% output data length
set(handles.LengthOutput,'String',num2str(EEG_len));
% output channels
ch_name=cell(1,size(handles.EEG,1));
for i=1:size(handles.EEG,1)
    ch_name{i}=['Ch ' num2str(i)];
end
set(handles.ChannelSelection,'string',ch_name);
set(handles.ChannelSelection,'value',handles.ch);
% change win_loc slide
set(handles.Global_View_Selection,'Max',size(handles.EEG,2)+1-handles.win);
set(handles.Global_View_Selection,'value',handles.win_loc);
set(handles.Global_View_Selection,'Min',1)
% change yrange slide
% set(handles.YRange_slide,'Max',handles.yrange(2)-mean(handles.yrange))
% set(handles.YRange_slide,'Min',handles.yrange(1)-mean(handles.yrange))
% set(handles.YRange_slide,'value',0)
% change win_len slide
set(handles.Win_Len_Slide,'Max',EEG_len);
set(handles.Win_Len_Slide,'value',handles.win);
set(handles.Win_Len_Slide,'Min',2);

guidata(hObject,handles);


%% Plot EEG
function PlotEEG(hObject,handles)

% get data
time=handles.time;
win_len=handles.win;
win_loc=handles.win_loc;
ch=handles.ch;
EEG=handles.EEG(ch,:);
% yrange=handles.yrange;
% plot global view
hold(handles.Global_View,'off');
plot(time,EEG,'b','parent',handles.Global_View,'linewidth',3);
% plot sub view
sub_time=time(win_loc:win_loc+win_len-1);
sub_EEG=EEG(win_loc:win_loc+win_len-1);
hold(handles.Sub_View,'off');
plot(sub_time,sub_EEG,'b','parent',handles.Sub_View);
set(handles.Sub_View,'XLim',[sub_time(1) sub_time(end)]);
if min(sub_EEG)~=max(sub_EEG)
    set(handles.Sub_View,'YLim',[min(sub_EEG) max(sub_EEG)]);
end
% plot red window
hold(handles.Global_View,'on');
% set(handles.Global_View,'YLim',yrange);
rec_y=get(handles.Global_View,'YLim');
rec_x=[time(win_loc) time(win_loc+win_len-1)];
plot([rec_x(1) rec_x(2)],[rec_y(1) rec_y(1)],'r','parent',handles.Global_View,'linewidth',2);
plot([rec_x(1) rec_x(2)],[rec_y(2) rec_y(2)],'r','parent',handles.Global_View,'linewidth',2);
plot([rec_x(1) rec_x(1)],[rec_y(1) rec_y(2)],'r','parent',handles.Global_View,'linewidth',2);
plot([rec_x(2) rec_x(2)],[rec_y(1) rec_y(2)],'r','parent',handles.Global_View,'linewidth',2);
% clear global view tick
set(handles.Global_View,'XTick',[]);
set(handles.Global_View,'YTick',[]);
set(handles.Global_View,'XLim',[time(1) time(end)]);

guidata(hObject,handles);



%% Callback for Win_Len_Slide (win)
function Win_Len_Slide_Callback(hObject, eventdata, handles)
% hObject    handle to Win_Len_Slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.EEG)
    win_len=floor(get(hObject,'value'));
    handles.win=win_len;
    
    win_loc=handles.win_loc;
    if win_loc>size(handles.EEG,2)+1-win_len
        win_loc=size(handles.EEG,2)+1-win_len;
        handles.win_loc=win_loc;
        set(handles.Global_View_Selection,'value',win_loc);
    end
    set(handles.Global_View_Selection,'Max',size(handles.EEG,2)+1-win_len+0.1);
    
    PlotEEG(hObject,handles)
    
    guidata(hObject,handles);
end



%% Create Function for Win_Len_Slide
function Win_Len_Slide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Win_Len_Slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
