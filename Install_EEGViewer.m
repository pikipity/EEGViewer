function Install_EEGViewer
    
    path=fileparts(mfilename('fullpath'));
    filelist=dir(path);
    temp=[];
    num=1;
    for i=1:length(filelist)
        file=filelist(i).name;
        file(file==' ')='';
        if file(1)=='v' && length(file)==2
            if ~isempty(str2num(file(2:end)))
                temp(num)=str2num(file(2:end));
                num=num+1;
            end
        end
    end
    temp=sort(temp);
    file=[path filesep 'v' num2str(temp(end))];
    try
        addpath(file)
        savepath;
        disp(['"' file '" has been added in your path.'])
        disp('Install successfully')
        disp('Please use the command "EEGViewer" to run this program');
    catch err
        disp('Error:')
        disp(err)
    end
end