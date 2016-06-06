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

set(0,'Units','characters')
f=gcf;
set(f,'units','characters','position',[1450 712 1194 686])
h=get(gcf,'Children');

% Appdata initialization
handles.time=[];
handles.EEG=[];
handles.win=[];
handles.ch=1;
handles.win_loc=[];
% handles.yrange=[];

% clear 3 views
set(handles.Global_View,'XTick',[]);
set(handles.Global_View,'YTick',[]);
set(handles.Sub_View,'XTick',[]);
set(handles.Sub_View,'YTick',[]);
set(handles.Freq_View,'XTick',[]);
set(handles.Freq_View,'YTick',[]);

% button color
set(handles.LoadDataButton,'backgroundcolor',[0.94 0.94 0.94]);

% Update handles structure
guidata(hObject, handles);

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
    
    handles.win_loc=floor(get(hObject,'value'));
    
    handles=UpdateFuc_Global_View_Selection(handles);
    
    handles=PlotEEG(handles);
    
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

addlistener(hObject,'ContinuousValueChange',@(hObject,eventdata)VisualEEG('Global_View_Selection_Callback',hObject,eventdata,guidata(hObject)));


%% Callback Function for ChannelSelection (ch)
function ChannelSelection_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.EEG)
    handles.ch=floor(get(hObject,'value'));
    
    handles=init_all_control(handles);
    
    handles=PlotEEG(handles);
    
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
                if EEG_len<20
                    errordlg('Length of EEG must be larger than 20.','File Error');
                    error=1;
                else
                    handles=init_all_control(handles);
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
    handles=PlotEEG(handles);
end

% store data
guidata(hObject,handles);


%% Update LengthOutPut
function handles=UpdateFuc_LengOutPut(handles)

EEG_len=length(handles.time);
set(handles.LengthOutput,'String',num2str(EEG_len));

%% Update ChannelSelection
function handles=UpdateFuc_ChannelSelection(handles)

ch_name=cell(1,size(handles.EEG,1));
for i=1:size(handles.EEG,1)
    ch_name{i}=['Ch ' num2str(i)];
end
set(handles.ChannelSelection,'string',ch_name);
set(handles.ChannelSelection,'value',handles.ch);

%% Update Global_View_Selection
function handles=UpdateFuc_Global_View_Selection(handles)

if handles.win_loc>size(handles.EEG,2)+1-handles.win
    handles.win_loc=size(handles.EEG,2)+1-handles.win;
elseif handles.win_loc<1
    handles.win_loc=1;
end

set(handles.Global_View_Selection,'value',handles.win_loc);
set(handles.Global_View_Selection,'Max',size(handles.EEG,2)+1-handles.win+0.1);
set(handles.Global_View_Selection,'Min',1)

stepsize=get(handles.Global_View_Selection,'sliderstep');
visibal_len=handles.win;
total_len=size(handles.EEG,2);
stepsize(2)=visibal_len/(total_len-visibal_len);
stepsize(1)=0.01;
if stepsize(1)>stepsize(2)
    stepsize(1)=stepsize(2)*0.1;
end
try
    set(handles.Global_View_Selection,'sliderstep',stepsize);
catch err
    disp(stepsize)
end

%% Update Win_Len_Slide
function handles=UpdateFuc_WinLen_Slide(handles)

EEG_len=length(handles.time);

if handles.win>EEG_len
    handles.win=EEG_len;
elseif handles.win<20
    handles.win=20;
end

set(handles.Win_Len_Slide,'Max',EEG_len+0.1);
set(handles.Win_Len_Slide,'value',handles.win);
set(handles.Win_Len_Slide,'Min',20);

handles=UpdateFuc_Global_View_Selection(handles);

%% Update Output_Total_Time
function handles=UpdateFuc_Output_Total_Time(handles)

time=handles.time;
set(handles.Output_Total_Time,'String',num2str(time(end)-time(1)));




%% Init Control Pannels
function handles=init_all_control(handles)

% output data length
handles=UpdateFuc_LengOutPut(handles);
% output time length
handles=UpdateFuc_Output_Total_Time(handles);
% output channels
handles=UpdateFuc_ChannelSelection(handles);
% change win_len slide and win_loc slide
handles=UpdateFuc_WinLen_Slide(handles);


%% Plot EEG
function handles=PlotEEG(handles)

% get data
time=handles.time;
Fs=1/(time(3)-time(2));
win_len=handles.win;
win_loc=handles.win_loc;
ch=handles.ch;
EEG=handles.EEG(ch,:);
% yrange=handles.yrange;
detrend_flag=get(handles.Detrend,'Value');

% get filter parameter
butter_order=str2num(get(handles.FilterParameter1_Input,'string'));
low_cutoff_f=str2num(get(handles.FilterParameter2_Input,'string'));
high_cutoff_f=str2num(get(handles.FilterParameter3_Input,'string'));
if isempty(butter_order) || isempty(low_cutoff_f) || isempty(high_cutoff_f)||...
        (low_cutoff_f<=0 && high_cutoff_f>=Fs/2)
    butter_flag=0;
    if isempty(butter_order)
        butter_order='Integer Order';
    end
    if isempty(low_cutoff_f)
        low_cutoff_f='Freq in Hz';
    end
    if isempty(high_cutoff_f)
        high_cutoff_f='Freq in Hz';
    end
else
    butter_flag=1;
    butter_order=floor(butter_order);
    if high_cutoff_f>=Fs/2
        butter_type='high';
        try
            [butter_b,butter_a]=butter(butter_order,low_cutoff_f/(Fs/2),butter_type);
        catch err
            butter_flag=0;
            butter_order='Unsuitable';
        end
    elseif low_cutoff_f<=0
        butter_type='low';
        try
            [butter_b,butter_a]=butter(butter_order,high_cutoff_f/(Fs/2),butter_type);
        catch err
            butter_flag=0;
            butter_order='Unsuitable';
        end
    else
        butter_type='bandpass';
        try
            [butter_b,butter_a]=butter(butter_order,[low_cutoff_f high_cutoff_f]./(Fs/2),butter_type);
        catch err
            butter_flag=0;
            butter_order='Unsuitable';
        end
    end
end

set(handles.FilterParameter1_Input,'string',num2str(butter_order));
set(handles.FilterParameter2_Input,'string',num2str(low_cutoff_f));
set(handles.FilterParameter3_Input,'string',num2str(high_cutoff_f));


% plot global view
hold(handles.Global_View,'off');
if detrend_flag
    plot_EEG=detrend(EEG);
else
    plot_EEG=EEG;
end
if butter_flag
    try
        temp=filtfilt(butter_b,butter_a,plot_EEG);
    catch err
        temp=NaN;
    end
    if sum(isnan(temp))>0
        set(handles.FilterParameter1_Input,'string','Unsuitable');
        butter_flag=0;
    else
        plot_EEG=temp;
    end
end
plot(time,plot_EEG,'b','parent',handles.Global_View,'linewidth',3);

% plot sub view
sub_time=time(win_loc:win_loc+win_len-1);
sub_EEG=EEG(win_loc:win_loc+win_len-1);
if detrend_flag
    sub_EEG=detrend(sub_EEG);
end
if butter_flag
    try
        temp=filtfilt(butter_b,butter_a,sub_EEG);
    catch err
        temp=NaN;
    end
    if sum(isnan(temp))>0
        set(handles.FilterParameter1_Input,'string','Unsuitable');
        butter_flag=0;
    else
        sub_EEG=temp;
    end
end
hold(handles.Sub_View,'off');
plot(sub_time,sub_EEG,'b','parent',handles.Sub_View);
set(handles.Sub_View,'XLim',[sub_time(1) sub_time(end)]);
if min(sub_EEG)~=max(sub_EEG)
    set(handles.Sub_View,'YLim',[min(sub_EEG) max(sub_EEG)]);
end
xlabel('Time (s)','parent',handles.Sub_View);
if butter_flag
    if strcmp(butter_type,'high')
        ylabel('With Highpass Filter','parent',handles.Sub_View);
    elseif strcmp(butter_type,'low')
        ylabel('With Lowpass Filter','parent',handles.Sub_View);
    elseif strcmp(butter_type,'bandpass')
        ylabel('With Bandpass Filter','parent',handles.Sub_View);
    end
else
    ylabel('No Butter Filter','parent',handles.Sub_View);
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

% plot frequcy view
min_freq=str2num(get(handles.Min_Freq,'string'));
max_freq=str2num(get(handles.Max_Freq,'string'));
L=length(sub_EEG);
NFFT=2^nextpow2(L);
fft_result=fft(sub_EEG,NFFT)/L;
fft_result=fft_result(1:NFFT/2+1);
frequency=Fs/2*linspace(0,1,NFFT/2+1);
if ~isempty(min_freq)
    [~,min_f_index]=min(abs(frequency-min_freq));
else
    min_f_index=1;
end
if ~isempty(max_freq)
    [~,max_f_index]=min(abs(frequency-max_freq));
else
    max_f_index=length(frequency);
end
if min_f_index>=max_f_index
    min_f_index=1;
    max_f_index=length(frequency);
end
set(handles.Min_Freq,'string',num2str(frequency(min_f_index)));
set(handles.Max_Freq,'string',num2str(frequency(max_f_index)));
plot(frequency(min_f_index:max_f_index),2.*abs(fft_result(min_f_index:max_f_index)),'b','parent',handles.Freq_View);
set(handles.Freq_View,'XLim',[frequency(min_f_index) frequency(max_f_index)])
if min(2.*abs(fft_result))~=max(2.*abs(fft_result))
    set(handles.Freq_View,'YLim',[min(2.*abs(fft_result(min_f_index:max_f_index))) max(2.*abs(fft_result(min_f_index:max_f_index)))])
end
xlabel('Frequency (Hz)','parent',handles.Freq_View);
ylabel('Amplitudes','parent',handles.Freq_View);



%% Callback for Win_Len_Slide (win)
function Win_Len_Slide_Callback(hObject, eventdata, handles)
% hObject    handle to Win_Len_Slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.EEG)
    handles.win=floor(get(hObject,'value'));
    
    handles=UpdateFuc_WinLen_Slide(handles);
    
    handles=PlotEEG(handles);
    
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

addlistener(hObject,'ContinuousValueChange',@(hObject,eventdata)VisualEEG('Win_Len_Slide_Callback',hObject,eventdata,guidata(hObject)));



function Min_Freq_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Freq as text
%        str2num(get(hObject,'String')) returns contents of Min_Freq as a double
if ~isempty(handles.EEG)
    handles=PlotEEG(handles);

    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function Min_Freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Freq_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Freq as text
%        str2num(get(hObject,'String')) returns contents of Max_Freq as a double
if ~isempty(handles.EEG)
    handles=PlotEEG(handles);

    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function Max_Freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Detrend.
function Detrend_Callback(hObject, eventdata, handles)
% hObject    handle to Detrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Detrend
if ~isempty(handles.EEG)

    handles=PlotEEG(handles);

    guidata(hObject,handles);
end


function FilterParameter1_Input_Callback(hObject, eventdata, handles)
% hObject    handle to FilterParameter1_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterParameter1_Input as text
%        str2num(get(hObject,'String')) returns contents of FilterParameter1_Input as a double
if ~isempty(handles.EEG)
    handles=PlotEEG(handles);

    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function FilterParameter1_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterParameter1_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FilterParameter2_Input_Callback(hObject, eventdata, handles)
% hObject    handle to FilterParameter2_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterParameter2_Input as text
%        str2num(get(hObject,'String')) returns contents of FilterParameter2_Input as a double
if ~isempty(handles.EEG)
    handles=PlotEEG(handles);

    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function FilterParameter2_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterParameter2_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FilterParameter3_Input_Callback(hObject, eventdata, handles)
% hObject    handle to FilterParameter3_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterParameter3_Input as text
%        str2num(get(hObject,'String')) returns contents of FilterParameter3_Input as a double
if ~isempty(handles.EEG)
    handles=PlotEEG(handles);

    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function FilterParameter3_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterParameter3_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
