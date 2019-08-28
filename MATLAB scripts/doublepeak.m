% use merge_data first
% layer and column number
c1 = 2;
c2 = 2;
% event energy
eventenergy = 30;
%%
% the tau lepton and the hadronic shower are simulated seperately
ftau = sprintf('../tau_%dTeV.csv',eventenergy);
fhad = sprintf('../had_%dTeV.csv',eventenergy);

fid = fopen(ftau);
dat_tau = textscan(fid, '%f%f%f%f%f%f%f%f%f','Delimiter',',');
fid = fclose(fid);
dat_tau = cell2mat(dat_tau);

fid = fopen(fhad);
dat_had = textscan(fid, '%f%f%f%f%f%f%f%f%f','Delimiter',',');
fid = fclose(fid);
dat_had = cell2mat(dat_had);
%%
onecell = [];
twocell = [];
threecell =[];
% combine each hadronic shower response with tau response
for ehad = 0:9 
    for etau = 0:19
        tab = zeros(1,12);
        for k = 1:12
            had = SelectEvent(dat_had,ehad);
            tau = SelectEvent(dat_tau,etau);
            a = isdoublepeak(had,tau,c1,c2,k);
            fprintf('%d',a);
            tab(1,k) = a;
        end
        fprintf('\n');
        
        % one cell threshold
        if (sum(tab == 2)+sum(tab == 1))>0
            onecell = [onecell;ehad,etau];
        end
        % two cell threshold
        if (sum(tab == 2)+sum(tab == 1))>1
            twocell = [twocell;ehad,etau];
        end
        % two cell threshold
        if (sum(tab == 2)+sum(tab == 1))>2
            threecell = [threecell;ehad,etau];
        end
    end
end
disp('======================================================');
disp(onecell);
disp(length(onecell));
disp('=====================================================');
disp(twocell);
disp(length(twocell));
disp('======================================================');
disp(threecell);
disp(length(threecell));
quit

%%
function v = SelectEvent(dat,e)
% return a n*9 matrix which contains hit information from event n  
    % column 9 specifies the event id
    event = dat(:,9) == e;
    v = dat(event,:);
end

function [hit, distance, angle] = SelectPMT(dat,lay,col,cell)
% return a column vector which contains hit information of a selected PMT
% the distance and angle from the event vertex to the PMT
    %3*3,input 1-3,id 0-2
    c1 = dat(:,1) == lay-1;
    c2 = dat(:,2) == col-1;
    c3 = dat(:,3) == cell-1;
    select = c1&c2&c3;
    v = dat(select,:);
    
    % arrival time
    hit = v(:,4);
    
    s = [-20,-10,-75 + 12.5];
    x = [25,75,125]-75;
    y = [25,75,125]-75;
    z = (6.25:12.5:143.75)-75; 
    dx = x(lay)-s(1);
    dy = y(col)-s(2);
    dz = z(cell)-s(3);
    distance = sqrt(sum(dx^2+dy^2+dz^2));
    angle = atan(sqrt(dx^2+dy^2)/dz)/pi*180;
end

function [FitResults,chisquare] = bestfit_doublepeak(x,y,distance)
% fit x,y data with the sum of two bifercated gaussians
    
    % guess peak location bases on the distance
    peak = distance/0.3/0.75;
    start = [peak,10];
    
    Results = zeros(56,4);
    GOF = zeros(14,2);
    % try different ratios
    ratio = 0.3:0.2:3;
    for i = 1:14
        [Results(2*i-1:2*i,:),GOF(i,:)]=myfit(x,y,2,[start, start],ratio(i),6,0);
    end
    % find the best results
    idx = find(GOF(:,2) == min(GOF(:,2)));
    FitResults = [Results(idx*2-1:idx*2,:),[ratio(idx);ratio(idx)]];
    chisquare = GOF(idx,2);
end

function [FitResults] = bestfit_singlepeak(x,y,distance)
% fit x,y data with the sum of two bifercated gaussians

    % guess peak location bases on the distance
    peak = distance/0.3/0.75;
    start = [peak,5];
    
    Results = zeros(28,4);
    GOF = zeros(28,2);
    
    % try different ratios
    ratio = 0.3:0.1:3;
    for i = 1:28
        [Results(i,:),GOF(i,:)]=myfit(x,y,1,start,ratio(i),2,0);
    end
    idx = find(GOF(:,2) == min(GOF(:,2)));
    FitResults = [Results(idx,:),ratio(idx)];
end

function [dpeak] = isdoublepeak(had,tau,lay,col,cell)
% return 2 if a double-peak peak pattern is identified
% return 1 if one peak and at least one bump is found
% other wise returns 0, some exceptions are:
% return -1 of the PMTis at the cherenkov emission angle ~40 degree or too
% few photons are received
% return -2 if binning error

    [hit_had] = SelectPMT(had,lay,col,cell);%2,1
    [hit_tau, distance,angle] = SelectPMT(tau,lay,col,cell);
    hit_sum = [hit_had;hit_tau];
    if (angle > 35 && angle <45) ||...
        dpeak = -1;
        return
    end

    min_limit = distance/0.3/0.75-10;
    max_limit = 2*mean(hit_sum)-min_limit;
    bin = 0.25;
    edge = min_limit:bin:max_limit;

    if isempty(edge)
        dpeak = -2;
	return
    end

    h = histogram(hit_sum,edge,'DisplayStyle','stairs');

    x = h.BinEdges(1,1:(length(h.BinEdges)-1))+bin/2;
    y = h.BinCounts;
    Results = bestfit_singlepeak(x,y,distance);
   
    std1 = Results(1,5)*Results(1,4)/(Results(1,5)+1)/2.35482;
    std2 = Results(1,4)/(Results(1,5)+1)/2.35482;
    pos = Results(1,2);
    
    % set new range
    min_limit = pos-std1*2.5;
    max_limit = pos+std2*2.5;
    hit_sum = hit_sum(hit_sum>min_limit & hit_sum<max_limit);
    bin = round((max_limit-min_limit)/40*4)/4;
    % histogram
    edge = min_limit:bin:max_limit;
    
    if isempty(edge)
	dpeak = -2;
	return
    end
    h = histogram(hit_sum,edge,'DisplayStyle','stairs');
    
    %histogram(hit_had,edge,'DisplayStyle','stairs');
    %histogram(hit_tau,edge,'DisplayStyle','stairs')
    x = h.BinEdges(1,1:(length(h.BinEdges)-1))+bin/2;
    y = h.BinCounts;
    
    if max(y) < 5
        dpeak = 0;
        return
    end
    
    % fit double-peak
    Results = bestfit_doublepeak(x,y,distance);
   
    % plot fit results
    x = min_limit:(bin/5):max_limit; 
    b1 = bigaussian(x,Results(1,2),Results(1,4),Results(1,3),Results(1,5));
    b2 = bigaussian(x,Results(2,2),Results(2,4),Results(2,3),Results(2,5));
    %plot(x,b1,x,b2,x,b1+b2);
    %chisquare = sum((y-(b1+b2)).^2./(b1+b2));
    %format1 = "Chisquare/dof:%f";
    %format2 = "distance %f,angle %f,t = %f ";
    %title({sprintf(format1,chisquare/(length(x)-6));sprintf(format2,distance,angle,distance/0.3/0.75)});
    
    % ignore peaks that are too narrow/wide or too low in magnitude
    ra = (Results(1,4)/Results(1,3))/(Results(2,4)/Results(2,3));
    if Results(1,3)/Results(2,3) > 3.5 || Results(2,3)/Results(1,3) > 3.5 ||...
       ra > 8 || ra < 0.125 || Results(1,4)<1 || Results(2,4)<1 || ...
       Results(1,3) < 5 || Results(2,3) < 5
        dpeak = 0;
        return
    end
    
    % Find the location of hte peaks
    [pks,locs] = findpeaks(b1+b2,x);
    %text(locs+.02,pks,num2str((1:numel(pks))'))
   
    if length(pks) == 2 
        dpeak = 2;        
    else
        % find bumps(inflection point where the derivative is approximately zero)
        b_sum = b1+b2;
        d1 = diff(b_sum);
        id = sign(diff(d1));
        in = strfind(id,[-1 1]);
        in = [in,strfind(id,[1 -1])];
        % derivative at the inflection point
        in = in(abs(d1(in))<1);
        
        if length(in)==1
            %text(x(in)+.02,b_sum(in),num2str((1:numel(b1(in)+b2(in)))'));
            dpeak = 1;
        else
            dpeak = 0;
        end
    end

end
