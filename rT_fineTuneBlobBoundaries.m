function newMask = rT_fineTuneBlobBoundaries(Ioriginal,resizeFactor,mask)

% Here, we show the user the original, full resolution photo for manual
% editing
s = size(Ioriginal);
fullMask = imresize(logical(imresize(mask,1/resizeFactor)),[s(1) s(2)]);
% Find the Centroid of this particular blob in the original image
stats = regionprops(fullMask,'Centroid','MajorAxisLength');
L = ceil(stats.MajorAxisLength);
C = ceil(stats.Centroid);

% Draw a bounding box around the blob so it's not expensive to load the
% original image each time
smImg = Ioriginal(C(2)-L:min(C(2)+L,s(1)),C(1)-L:C(1)+L,:);
curMask = fullMask(C(2)-L:min(C(2)+L,s(1)),C(1)-L:C(1)+L);
% Obtain the boundaries of the mask as xy pairs
poly = mask2poly(curMask,'outer','mindist');
% Downsample the list of points found to roughly 15 pairs
poly_sm = downsample(poly,floor(size(poly,1)/15));

% Show a zoomed in image
figAx = figure;
set(figAx,'units','normalized');
set(figAx,'outerPosition',[0 0 1 1]);
imshow(smImg)
hold on
contour(curMask,1,'b')

pix = impoly(gca,poly_sm);
position = wait(pix);
newMask = createMask(pix);
delete(pix);
close

% This mask we made was full size. Scale it to the correct resize factor.
newMaskFullSize = zeros(s(1),s(2));
newMaskFullSize(C(2)-L:min(C(2)+L,s(1)),C(1)-L:C(1)+L,:) = newMask;
newMask = imresize(logical(newMaskFullSize),resizeFactor);







