function [coralImage,stats,pixToCM,I] = rT_preProcessImage(I,cmThreshold,resizeFactor,c,pix2cm)

% If subtraction artifacts are found, set those pixels to zero.
I = rT_fixSubtractionArtifacts(I);

% Orient image so that the biggest area of the grid faces the diver
I = rT_orientImageConsistently(I);

% Get the Region of Interest Mask - this is where we search for corals
%[coralMask,ropeMask] = getROIMask(I,Ilab);
[coralMask,ropeMask] = rT_getROIMask_v2(I,resizeFactor,c);

% one pixel is this many centimeters
% if it is specified by the user, don't evaluate this:
if pix2cm==0
    pixToCM = rT_getPix2CMratio(I,ropeMask,resizeFactor);
else
    pixToCM = pix2cm;
end

% Obtain the map of corals by adaptive thresholding
%coralImage = logical(adaptiveThresholding(coralMask,I,Ilab));
coralImage = rT_adaptiveThresholding2(coralMask,I,cmThreshold,pixToCM,resizeFactor);

coralImage = rT_filterCoralsbySizeInImage(coralImage,cmThreshold,pixToCM);
stats = regionprops(logical(coralImage),'All');