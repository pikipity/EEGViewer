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
    addpath(file)
    savepath;
end