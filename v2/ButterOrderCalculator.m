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

% Last Modified by GUIDE v2.5 08-Jun-2016 11:19:01

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
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ButterOrderCalculator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ButterOrderCalculator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FilterType.
function FilterType_Callback(hObject, eventdata, handles)
% hObject    handle to FilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilterType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterType


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


% --- Executes on button press in CalButton.
function CalButton_Callback(hObject, eventdata, handles)
% hObject    handle to CalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
