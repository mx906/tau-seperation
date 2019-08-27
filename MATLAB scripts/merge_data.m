dat = [];
dir = "E:\Documents\MATLAB\";
for i = 0:1:19
    format = "tau20_%d_nt_Ntuple.csv";
    fid = fopen(dir+sprintf(format,i));
    dat1 = textscan(fid, '%f%f%f%f%f%f%f%f%f','Delimiter',',','HeaderLines',13);
    fid = fclose(fid);
    dat1 = cell2mat(dat1);
    dat1(isnan(dat1(:,1)),:)=[];
    dat = [dat;dat1];
end

event = 0;
for i = 1:length(dat)
    if dat(i,9)~=event && dat(i,9)~=0
        event = dat(i,9);
    else
        dat(i,9)=event;
    end
end

csvwrite(dir+"tau_20TeV.csv",dat);