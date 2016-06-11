function varargout = ButterOrderCalculator(varargin)
% BUTTERORDERCALCULATOR MATLAB code for ButterOrderCalculator.fig
%      BUTTERORDERCALCULATOR, by itself, creates a new BUTTERORDERCALCULATOR or raises the existing
%      singleton*.
%
%      H = BUTTERORDERCALCULATOR returns the handle to a new BUTTERORDERCALCULATOR or the handle to
%      the existing singleton*.
%
%      BUTTERORDERCALCULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUTTERORDERCALCULATOR.M with the given input arguments.
%
%      BUTTERORDERCALCULATOR('Property','Value',...) creates a new BUTTERORDERCALCULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ButterOrderCalculator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ButterOrderCalculator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ButterOrderCalculator

% Last Modified by GUIDE v2.5 11-Jun-2016 13:26:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ButterOrderCalculator_OpeningFcn, ...
                   'gui_OutputFcn',  @ButterOrderCalculator_OutputFcn, ...
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


% --- Executes just before ButterOrderCalculator is made visible.
function ButterOrderCalculator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ButterOrderCalculator (see VARARGIN)

% Choose default command line output for ButterOrderCalculator
if ~isempty(varargin)
    handles.input=varargin{1};
    set(handles.FsOutput,'string',num2str(handles.input));
else
    handles.input=[];
    set(handles.FsOutput,'string','...');
end
handles.output=[];

% filter type
set(handles.FilterType,'string',{'Bandpass','Bandstop','Highpass','Lowpass'});
set(handles.FilterType,'value',1);

% button color
set(handles.FinishButton,'backgroundcolor',[1 1 1]);
set(handles.CancelButton,'backgroundcolor',[1 1 1]);
set(handles.PlotFreqResp,'backgroundcolor',[1 1 1]);

handles=CalOrder(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ButterOrderCalculator wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ButterOrderCalculator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

delete(hObject);


% --- Executes on selection change in FilterType.
function FilterType_Callback(hObject, eventdata, handles)
% hObject    handle to FilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilterType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterType
list=get(handles.FilterType,'String'); %{'Bandpass','Bandstop','Highpass','Lowpass'}
type=list{get(handles.FilterType,'value')};
switch type
    case 'Bandpass'
        set(handles.PassbandHigh,'enable','on');
        set(handles.PassbandLow,'enable','on');
        set(handles.StopbandHigh,'enable','on');
        set(handles.StopbandLow,'enable','on');
    case 'Bandstop'
        set(handles.PassbandHigh,'enable','on');
        set(handles.PassbandLow,'enable','on');
        set(handles.StopbandHigh,'enable','on');
        set(handles.StopbandLow,'enable','on');
    case 'Highpass'
        set(handles.PassbandHigh,'string','inf');
        set(handles.PassbandHigh,'enable','off');
        set(handles.PassbandLow,'enable','on');
        set(handles.StopbandHigh,'enable','on');
        set(handles.StopbandLow,'string','-inf');
        set(handles.StopbandLow,'enable','off');
    case 'Lowpass'
        set(handles.StopbandHigh,'string','inf');
        set(handles.StopbandHigh,'enable','off');
        set(handles.StopbandLow,'enable','on');
        set(handles.PassbandHigh,'enable','on');
        set(handles.PassbandLow,'string','-inf');
        set(handles.PassbandLow,'enable','off');
end

handles=CalOrder(handles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function FilterType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PassbandLow_Callback(hObject, eventdata, handles)
% hObject    handle to PassbandLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PassbandLow as text
%        str2double(get(hObject,'String')) returns contents of PassbandLow as a double

handles=CalOrder(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PassbandLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PassbandLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PassbandHigh_Callback(hObject, eventdata, handles)
% hObject    handle to PassbandHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PassbandHigh as text
%        str2double(get(hObject,'String')) returns contents of PassbandHigh as a double

handles=CalOrder(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PassbandHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PassbandHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StopbandLow_Callback(hObject, eventdata, handles)
% hObject    handle to StopbandLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StopbandLow as text
%        str2double(get(hObject,'String')) returns contents of StopbandLow as a double

handles=CalOrder(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function StopbandLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopbandLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StopbandHigh_Callback(hObject, eventdata, handles)
% hObject    handle to StopbandHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StopbandHigh as text
%        str2double(get(hObject,'String')) returns contents of StopbandHigh as a double

handles=CalOrder(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function StopbandHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopbandHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rp_Callback(hObject, eventdata, handles)
% hObject    handle to Rp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rp as text
%        str2double(get(hObject,'String')) returns contents of Rp as a double

handles=CalOrder(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Rp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rs_Callback(hObject, eventdata, handles)
% hObject    handle to Rs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rs as text
%        str2double(get(hObject,'String')) returns contents of Rs as a double

handles=CalOrder(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Rs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=[];
guidata(hObject,handles);
uiresume(handles.figure1);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    handles.output=[];
    guidata(hObject,handles);
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    handles.output=[];
    guidata(hObject,handles);
    delete(hObject);
end


% --- Executes on button press in FinishButton.
function FinishButton_Callback(hObject, eventdata, handles)
% hObject    handle to FinishButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);

uiresume(handles.figure1);


function handles=CalOrder(handles)
% get data
Fs=handles.input;
if isempty(Fs)
    set(handles.StateOutput,'string','No input')
    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
else
    list=get(handles.FilterType,'String'); %{'Bandpass','Bandstop','Highpass','Lowpass'}
    type=list{get(handles.FilterType,'value')};
    switch type
        case 'Bandpass'
            wp1=str2num(get(handles.PassbandLow,'string'));
            if isempty(wp1)
                set(handles.StateOutput,'string','Unsuitable low passband frequency')
                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
            else
                wp2=str2num(get(handles.PassbandHigh,'string'));
                if isempty(wp2)
                    set(handles.StateOutput,'string','Unsuitable high passband frequency')
                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                else
                    ws1=str2num(get(handles.StopbandLow,'string'));
                    if isempty(ws1)
                        set(handles.StateOutput,'string','Unsuitable low stopband frequency')
                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                    else
                        ws2=str2num(get(handles.StopbandHigh,'string'));
                        if isempty(ws2)
                            set(handles.StateOutput,'string','Unsuitable high stopband frequency')
                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                        else
                            if 0<ws1 && ws1<wp1 && wp1< wp2 && wp2<ws2 && ws2<Fs/2
                                rp=str2num(get(handles.Rp,'string'));
                                if isempty(rp)
                                    set(handles.StateOutput,'string','Unsuitable passband ripple')
                                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                else
                                    rs=str2num(get(handles.Rs,'string'));
                                    if isempty(rs)
                                        set(handles.StateOutput,'string','Unsuitable stopband attenuation')
                                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                    else
                                        try
                                            [n,Wn] = buttord([wp1 wp2]./(Fs/2),[ws1 ws2]./(Fs/2),rp,rs);
                                            results.order=n;
                                            results.lowf=Wn(1).*(Fs/2);
                                            results.highf=Wn(2).*(Fs/2);
                                            results.type=type;handles.output=results;
                                            set(handles.CalResult,'string',num2str(n));
                                            set(handles.CutoffFrequencyResult,'string',[num2str(results.lowf) '--' num2str(results.highf)]);
                                            set(handles.DataLength,'string',num2str(2*n));
                                            set(handles.StateOutput,'string','Successful Calculation')
                                        catch err
                                            set(handles.StateOutput,'string',err.message)
                                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                        end
                                    end
                                end
                            else
                                set(handles.StateOutput,'string','Please check frequency band settings')
                                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                            end
                        end
                    end
                end
            end
        case 'Bandstop'
            wp1=str2num(get(handles.PassbandLow,'string'));
            if isempty(wp1)
                set(handles.StateOutput,'string','Unsuitable low passband frequency')
                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
            else
                wp2=str2num(get(handles.PassbandHigh,'string'));
                if isempty(wp2)
                    set(handles.StateOutput,'string','Unsuitable high passband frequency')
                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                else
                    ws1=str2num(get(handles.StopbandLow,'string'));
                    if isempty(ws1)
                        set(handles.StateOutput,'string','Unsuitable low stopband frequency')
                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                    else
                        ws2=str2num(get(handles.StopbandHigh,'string'));
                        if isempty(ws2)
                            set(handles.StateOutput,'string','Unsuitable high stopband frequency')
                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                        else
                            if 0<wp1 && wp1<ws1 && ws1< ws2 && ws2<wp2 && wp2<Fs/2
                                rp=str2num(get(handles.Rp,'string'));
                                if isempty(rp)
                                    set(handles.StateOutput,'string','Unsuitable passband ripple')
                                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                else
                                    rs=str2num(get(handles.Rs,'string'));
                                    if isempty(rs)
                                        set(handles.StateOutput,'string','Unsuitable stopband attenuation')
                                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                    else
                                        try
                                            [n,Wn] = buttord([wp1 wp2]./(Fs/2),[ws1 ws2]./(Fs/2),rp,rs);
                                            results.order=n;
                                            results.lowf=Wn(1).*(Fs/2);
                                            results.highf=Wn(2).*(Fs/2);
                                            results.type=type;handles.output=results;
                                            set(handles.CalResult,'string',num2str(n));
                                            set(handles.CutoffFrequencyResult,'string',[num2str(results.lowf) '--' num2str(results.highf)]);
                                            set(handles.DataLength,'string',num2str(2*n));
                                            set(handles.StateOutput,'string','Successful Calculation')
                                        catch err
                                            set(handles.StateOutput,'string',err.message)
                                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                        end
                                    end
                                end
                            else
                                set(handles.StateOutput,'string','Please check frequency band settings')
                                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                            end
                        end
                    end
                end
            end
        case 'Highpass'
            wp1=str2num(get(handles.PassbandLow,'string'));
            if isempty(wp1)
                set(handles.StateOutput,'string','Unsuitable low passband frequency')
                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
            else
                wp2=str2num(get(handles.PassbandHigh,'string'));
                if isempty(wp2)
                    set(handles.StateOutput,'string','Unsuitable high passband frequency')
                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                else
                    ws1=str2num(get(handles.StopbandLow,'string'));
                    if isempty(ws1)
                        set(handles.StateOutput,'string','Unsuitable low stopband frequency')
                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                    else
                        ws2=str2num(get(handles.StopbandHigh,'string'));
                        if isempty(ws2)
                            set(handles.StateOutput,'string','Unsuitable high stopband frequency')
                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                        else
                            if 0<ws2 && ws2<wp1 && wp1<Fs/2
                                rp=str2num(get(handles.Rp,'string'));
                                if isempty(rp)
                                    set(handles.StateOutput,'string','Unsuitable passband ripple')
                                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                else
                                    rs=str2num(get(handles.Rs,'string'));
                                    if isempty(rs)
                                        set(handles.StateOutput,'string','Unsuitable stopband attenuation')
                                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                    else
                                        try
                                            [n,Wn] = buttord(wp1./(Fs/2),ws2./(Fs/2),rp,rs);
                                            results.order=n;
                                            results.lowf=Wn.*(Fs/2);
                                            results.highf=inf;
                                            results.type=type;handles.output=results;
                                            set(handles.CalResult,'string',num2str(n));
                                            set(handles.CutoffFrequencyResult,'string',[num2str(results.lowf) '--' num2str(results.highf)]);
                                            set(handles.DataLength,'string',num2str(n));
                                            set(handles.StateOutput,'string','Successful Calculation')
                                        catch err
                                            set(handles.StateOutput,'string',err.message)
                                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                        end
                                    end
                                end
                            else
                                set(handles.StateOutput,'string','Please check frequency band settings')
                                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                            end
                        end
                    end
                end
            end
        case 'Lowpass'
            wp1=str2num(get(handles.PassbandLow,'string'));
            if isempty(wp1)
                set(handles.StateOutput,'string','Unsuitable low passband frequency')
                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
            else
                wp2=str2num(get(handles.PassbandHigh,'string'));
                if isempty(wp2)
                    set(handles.StateOutput,'string','Unsuitable high passband frequency')
                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                else
                    ws1=str2num(get(handles.StopbandLow,'string'));
                    if isempty(ws1)
                        set(handles.StateOutput,'string','Unsuitable low stopband frequency')
                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                    else
                        ws2=str2num(get(handles.StopbandHigh,'string'));
                        if isempty(ws2)
                            set(handles.StateOutput,'string','Unsuitable high stopband frequency')
                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                        else
                            if 0<wp2 && wp2<ws1 && ws1<Fs/2
                                rp=str2num(get(handles.Rp,'string'));
                                if isempty(rp)
                                    set(handles.StateOutput,'string','Unsuitable passband ripple')
                                    handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                else
                                    rs=str2num(get(handles.Rs,'string'));
                                    if isempty(rs)
                                        set(handles.StateOutput,'string','Unsuitable stopband attenuation')
                                        handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                    else
                                        try
                                            [n,Wn] = buttord(wp2./(Fs/2),ws1./(Fs/2),rp,rs);
                                            results.order=n;
                                            results.lowf=-inf;
                                            results.highf=Wn.*(Fs/2);
                                            results.type=type;handles.output=results;
                                            set(handles.CalResult,'string',num2str(n));
                                            set(handles.CutoffFrequencyResult,'string',[num2str(results.lowf) '--' num2str(results.highf)]);
                                            set(handles.DataLength,'string',num2str(n));
                                            set(handles.StateOutput,'string','Successful Calculation')
                                        catch err
                                            set(handles.StateOutput,'string',err.message)
                                            handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                                        end
                                    end
                                end
                            else
                                set(handles.StateOutput,'string','Please check frequency band settings')
                                handles.output=[];set(handles.CalResult,'string','...');set(handles.CutoffFrequencyResult,'string','...');set(handles.DataLength,'string','...');
                            end
                        end
                    end
                end
            end
    end
end


% --- Executes on button press in PlotFreqResp.
function PlotFreqResp_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFreqResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.StateOutput,'string'),'Successful Calculation')
    Fs=handles.input;
    L=60000;
    NFFT=2^nextpow2(L);
    frequency=Fs/2*linspace(0,1,NFFT/2+1);
    butter_order=handles.output.order;
    low_cutoff_f=handles.output.lowf;
    high_cutoff_f=handles.output.highf;
    if high_cutoff_f>=Fs/2
        butter_type='high';
        try
            [butter_b,butter_a]=butter(butter_order,low_cutoff_f/(Fs/2),butter_type);
        catch err
            butter_b=[];
            butter_a=[];
        end
    elseif low_cutoff_f<=0
        butter_type='low';
        try
            [butter_b,butter_a]=butter(butter_order,high_cutoff_f/(Fs/2),butter_type);
        catch err
            butter_b=[];
            butter_a=[];
        end
    else
        butter_type=get(handles.FilterType,'string');
        butter_type=butter_type{get(handles.FilterType,'value')};
        switch butter_type % {'Highpass', 'Lowpass','Bandpass','Bandstop'}
            case 'Bandpass'
                butter_type='bandpass';
            case 'Bandstop'
                butter_type='stop';
        end
        try
            [butter_b,butter_a]=butter(butter_order,[low_cutoff_f high_cutoff_f]./(Fs/2),butter_type);
        catch err
            butter_b=[];
            butter_a=[];
        end
    end
    if ~isempty(butter_b) && ~isempty(butter_a)
        h=freqz(butter_b,butter_a,frequency,Fs);
        figure;
        plot(frequency,20*log10(abs(h)),'b')
        axis([min(frequency) max(frequency) -1*str2num(get(handles.Rs,'string')) str2num(get(handles.Rp,'string'))])
        xlabel('Frequency (Hz)')
        ylabel('Magnitude (dB)')
        grid on
    else
        errordlg('Please check calculated results. Note: order cannot be inf','Error');
    end
else
    errordlg('Please calculate parameters first','Error');
end
