% Butterworth Filter 1
function [FilterWholeSig,FilterWindowSig,handles,error]=ButterworthFilter2(WholeSig,WindowSig,handles)
% get filter parameter
error=0;
butter_flag=get(handles.ButterworthFilter2Flag,'value');
butter_order=str2num(get(handles.ButterworthFilter2Order,'string'));
low_cutoff_f=str2num(get(handles.ButterworthFilter2LowF,'string'));
high_cutoff_f=str2num(get(handles.ButterworthFilter2HighF,'string'));
Fs=1/(handles.time(3)-handles.time(2));
butter_type='';

if butter_flag==0
    set(handles.ButterworthFilter2State,'string','Not Active');
    error=1;
else
    if isempty(butter_order) || isempty(low_cutoff_f) || isempty(high_cutoff_f)||...
            (low_cutoff_f<=0 && high_cutoff_f>=Fs/2) || low_cutoff_f>=high_cutoff_f
        butter_flag=0;
        if isempty(butter_order)
            error=2;
            set(handles.ButterworthFilter2State,'string','Unsuitable Order');
        elseif isempty(low_cutoff_f)
            error=3;
            set(handles.ButterworthFilter2State,'string','Unsuitable Low Freq');
        elseif isempty(high_cutoff_f)
            error=4;
            set(handles.ButterworthFilter2State,'string','Unsuitable High Freq');
        elseif (low_cutoff_f<=0 && high_cutoff_f>=Fs/2) || high_cutoff_f<=0
            error=5;
            set(handles.ButterworthFilter2State,'string','Unsuitable frequency band');
        elseif low_cutoff_f>=high_cutoff_f
            error=11;
            set(handles.ButterworthFilter2State,'string','Low Freq must lower than High Freq');
        end
    else
        butter_flag=1;
        butter_order=floor(butter_order);
        if butter_order>500
            butter_flag=0;
            error=6;
            set(handles.ButterworthFilter2State,'string','Too large Order');
        elseif butter_order<=0
            butter_flag=0;
            error=12;
            set(handles.ButterworthFilter2State,'string','Too small Order');
        else
            if high_cutoff_f>=Fs/2
                butter_type='high';
                [butter_b,butter_a]=butter(butter_order,low_cutoff_f/(Fs/2),butter_type);
            elseif low_cutoff_f<=0
                butter_type='low';
                [butter_b,butter_a]=butter(butter_order,high_cutoff_f/(Fs/2),butter_type);
            else
                butter_type=get(handles.ButerworthFilter2Type,'string');
                butter_type=butter_type{get(handles.ButerworthFilter2Type,'value')};
                switch butter_type % {'Highpass', 'Lowpass','Bandpass','Bandstop'}
                    case 'Bandpass'
                        butter_type='bandpass';
                    case 'Bandstop'
                        butter_type='stop';
                end
                [butter_b,butter_a]=butter(butter_order,[low_cutoff_f high_cutoff_f]./(Fs/2),butter_type);
                butter_order=2*butter_order;
            end
        end
    end
end

% filter signal
sub_error=[0,0];
if get(handles.FilterToWholeSignal,'value') && butter_flag
    if length(WholeSig)<=3*butter_order
        error=7;
        set(handles.ButterworthFilter2State,'string','Too large Order for whole signal');
        FilterWholeSig=WholeSig;
        sub_error(1)=1;
    else
        FilterWholeSig=filtfilt(butter_b,butter_a,WholeSig);
        if sum(isnan(FilterWholeSig))>0
            FilterWholeSig=WholeSig;
            sub_error(1)=1;
            error=9;
            set(handles.ButterworthFilter2State,'string','NaN in filtered whole signal');
        else
            set(handles.ButterworthFilter2State,'string','Active');
        end
    end
else
    FilterWholeSig=WholeSig;
    sub_error(1)=1;
end

if get(handles.FilterToWindowSignal,'value') && butter_flag
    if length(WindowSig)<=3*butter_order
        error=7;
        set(handles.ButterworthFilter2State,'string','Too large Order for windowed signal');
        FilterWindowSig=WindowSig;
        sub_error(2)=1;
    else
        FilterWindowSig=filtfilt(butter_b,butter_a,WindowSig);
        if sum(isnan(FilterWindowSig))>0
            FilterWindowSig=WindowSig;
            error=10;
            sub_error(2)=1;
            set(handles.ButterworthFilter2State,'string','NaN in filtered windowed signal');
        end
    end
else
    FilterWindowSig=WindowSig;
    sub_error(2)=1;
end

if sum(sub_error)==2
    butter_flag=0;
end

set(handles.ButterworthFilter2Flag,'value',butter_flag);
if ~isempty(butter_order)
    switch butter_type % {'Highpass', 'Lowpass','Bandpass','Bandstop'}
        case 'bandpass'
            butter_order=butter_order/2;
        case 'stop'
            butter_order=butter_order/2;
    end
    set(handles.ButterworthFilter2Order,'string',num2str(butter_order));
end
if ~isempty(low_cutoff_f)
    set(handles.ButterworthFilter2LowF,'string',num2str(low_cutoff_f));
end
if ~isempty(high_cutoff_f)
    set(handles.ButterworthFilter2HighF,'string',num2str(high_cutoff_f));
end