function [FitResults,GOF,residual,LowestError]=myfit(xx,yy,NumPeaks,newstart,extra,NumTrials,Plot)
% Modified from https://www.mathworks.com/matlabcentral/fileexchange/23611-peakfit-m

warning off all

global AA xxx PEAKHEIGHTS
PEAKHEIGHTS=zeros(1,NumPeaks);
AA=zeros(NumPeaks,600);
xxx=linspace(min(xx),max(xx),600);

n=length(xx);

% fminsearch options
options = optimset('TolX',1e-06,'Display','off','MaxFunEvals',1000 );
LowestError=1000; 
FitParameters=zeros(1,NumPeaks.*3); 
BestStart=zeros(1,NumPeaks.*2); 
height=zeros(1,NumPeaks); 
bestmodel=zeros(size(yy));
TrialParameters=zeros(1,NumPeaks.*3);

for k=1:NumTrials
    TrialParameters=fminsearch(@(lambda)(fitBiGaussian(lambda,xx,yy,extra)),newstart,options);
    % Construct model from Trial parameters
    A=zeros(NumPeaks,n);
    
    for m=1:NumPeaks
        A(m,:)=BiGaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
        xxrange=max(xx)-min(xx);
        for parameter=1:2:2*NumPeaks
            newstart(parameter)=newstart(parameter)+(xxrange.*(randn)./(NumPeaks+1));
            newstart(parameter+1)=newstart(parameter+1)*(1+(rand-.5)/100);
        end
    end % for NumPeaks
    
    model=PEAKHEIGHTS'*A;
    Heights=PEAKHEIGHTS;
    % Compare trial model to data segment and compute the fit error
    MeanFitError=100*norm(yy-model)./(sqrt(n)*max(yy));
    % Take only the single fit that has the lowest MeanFitError
    if MeanFitError<LowestError 
      if min(Heights)>=0  % Consider only fits with positive peak heights
        LowestError=MeanFitError;  % Assign LowestError to the lowest MeanFitError
        FitParameters=TrialParameters;  % Assign FitParameters to the fit with the lowest MeanFitError
        BestStart=newstart; % Assign BestStart to the start with the lowest MeanFitError
        height=Heights; % Assign height to the PEAKHEIGHTS with the lowest MeanFitError
        bestmodel=model; % Assign bestmodel to the model with the lowest MeanFitError
      end % if min(PEAKHEIGHTS)>0
   end % if MeanFitError<LowestError
end % for k (NumTrials)

err_i = yy + 2*(yy == 0);
chi_squared = sum((bestmodel-yy).^2./err_i);
GOF=[LowestError chi_squared];

AA=zeros(NumPeaks,600);
xxx=linspace(min(xx),max(xx),600);

for m=1:NumPeaks
    AA(m,:)=BiGaussian(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);
end % for NumPeaks

for m=1:NumPeaks
    width(m)=abs(FitParameters(2*m));
    if m==1
        FitResults=[round(m) FitParameters(2*m-1) height(m) width(m)];
    else
        FitResults=[FitResults ; [round(m) FitParameters(2*m-1) height(m) width(m)]];
    end % if m==1
end

residual=yy-bestmodel; 
if Plot ~= 0
    figure(Plot)
    subplot(2,1,1);
    plot(xx,yy,'b.'); % Plot the original signal in blue dots
    hold on
    yyy = zeros(1,length(xxx));
    for m=1:NumPeaks
       plot(xxx,height(m)*AA(m,:),'g');  % Plot the individual component peaks in green lines
       yyy = yyy + height(m)*AA(m,:);
    end
    plot(xxx,yyy,'r');
    
    subplot(2,1,2);
    plot(xx,residual,'m.')
    axis([min(xx) max(xx) min(residual) max(residual)]);
    xlabel('Residual Plot')
    if NumTrials>1
        title(['Best of ' num2str(NumTrials) ' fits'])
    else
        title(['Single fit'])
    end
end
end

function y = BiGaussian(x,pos,wid,r)
% bigaussian(x,pos,wid) = gaussian centered at pos, with FWHM = wid
%  r: ratio of widths of right side to left side
mask = x < pos;
if r~=0
    y1 = gaussian(x,pos,r*wid/(r+1)).*mask;
    y2 = gaussian(x,pos,wid/(r+1)).*not(mask);
    y = y1 + y2;
else
    y = gaussian(x,pos,wid).*not(mask);
end
end

function y = gaussian(x,pos,wid)
% gaussian(x,pos,wid) = gaussian centered at pos, with FWHM = wid
% FWHM = full width at half maximum
y = exp(-4*log(2)*((x-pos)./(wid)).^2);
end

function err = fitBiGaussian(lambda,t,y,shapeconstant)
global PEAKHEIGHTS
A= zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2
    A(:,j) = BiGaussian(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
    %A(:,j) = BiGaussian(t,lambda(3*j-2),lambda(3*j-1),lambda(3*j))';
end
PEAKHEIGHTS=abs(A\y');
z = A*PEAKHEIGHTS;

err_i = y + 2*(y == 0);
%err_i = z' + 0*(z' == 0);
err = sum((z-y').^2./err_i');
%err = norm(z-y');
end
