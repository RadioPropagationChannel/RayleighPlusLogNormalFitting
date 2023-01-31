function [pdfX, pdfY, CDFx,CDFy, step] = fpdfCDFbins(z, nBins)

[a,b] = hist(z,nBins);
a = a/length(z);
a = [0 a 0];
step = b(2)-b(1);

II = find(z < 0.0, 1);
if isempty(II)
    pdfX = [b(1)-step/2 b b(length(b))+step/2];
else
    pdfX = [0.0 b b(end)+step];
end

CDFx = pdfX;

pdfY = a;
CDFy = cumsum(a);

return
