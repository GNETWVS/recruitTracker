function coralImage = rT_filterCoralsbySizeInImage(Ibw,cmThreshold,pixToCM)

stats = regionprops(Ibw,'MajorAxisLength','PixelIdxList');
% Eliminate corals greater than a certain size
stats = rT_filterCoralsbySize(stats,cmThreshold,pixToCM);
coralImage = logical(rT_makeMaskFromStats(stats,size(Ibw)));