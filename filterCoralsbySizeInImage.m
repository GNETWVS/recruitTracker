function coralImage = filterCoralsbySizeInImage(Ibw,cmThreshold,pixToCM)

stats = regionprops(Ibw,'MajorAxisLength','PixelIdxList');
% Eliminate corals greater than a certain size
stats = filterCoralsbySize(stats,cmThreshold,pixToCM);
coralImage = logical(makeMaskFromStats(stats,size(Ibw)));