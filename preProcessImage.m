function [coralImage,stats,pixToCM,I] = preProcessImage(I,cmThreshold,resizeFactor,c)

% If subtraction artifacts are found, set those pixels to zero.
I = fixSubtractionArtifacts(I);

% Orient image so that the biggest area of the grid faces the diver
I = orientImageConsistently(I);

% Get the Region of Interest Mask - this is where we search for corals
%[coralMask,ropeMask] = getROIMask(I,Ilab);
[coralMask,ropeMask] = getROIMask_v2(I,resizeFactor,c);

% one pixel is this many centimeters
pixToCM = getPix2CMratio(I,ropeMask,resizeFactor);

% Obtain the map of corals by adaptive thresholding
%coralImage = logical(adaptiveThresholding(coralMask,I,Ilab));
coralImage = adaptiveThresholding2(coralMask,I,cmThreshold,pixToCM,resizeFactor);

coralImage = filterCoralsbySizeInImage(coralImage,cmThreshold,pixToCM);
stats = regionprops(logical(coralImage),'All');