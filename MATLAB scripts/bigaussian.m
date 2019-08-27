function y = bigaussian(x,pos,wid,amp,r)
% bigaussian(x,pos,wid) = gaussian centered at pos, with FWHM = wid
%  r: ratio of widths of right side to left side
mask = x < pos;
if r~=0
    y1 = gaussian(x,pos,r*wid/(r+1),amp).*mask;
    y2 = gaussian(x,pos,wid/(r+1),amp).*not(mask);
    y = y1 + y2;
else
    y = gaussian(x,pos,wid,amp).*not(mask);
end

end

function y = gaussian(x,pos,wid,amp)
% gaussian(x,pos,wid) = gaussian centered at pos, with FWHM = wid
% FWHM = full width at half maximum
y = amp*exp(-4*log(2)*((x-pos)./(wid)).^2);
end