function stats = filterCoralsbySize(stats,cmThreshold,pix2cm)

% cmThreshold is the absolute dimensions of corals to be eliminated
% pix2cm is the conversion from pixels to centimeters for this particular
% image

% cmThreshold is a 2-element vector in centimeters, the first element is
% the smallest coral we will accept, and the second is the largest we will
% keep.

% This is in pixels
majorAxisDiameter = [stats.MajorAxisLength];
% Threshold in pixels for the upper and lower bound
pixThreshold = cmThreshold .* pix2cm;
stats((majorAxisDiameter > pixThreshold(2)) | (majorAxisDiameter < pixThreshold(1))) = [];
