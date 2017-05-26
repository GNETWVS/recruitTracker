function [coralMask,ropeMask] = getROIMask_v2(I,resizeFactor,c)
% save the original image that was passed in

% create a tiny version of the image
f = 0.05;
sor = size(I);
s = ceil(f.*sor./resizeFactor);

I = imresize(I,[s(1),s(2)]);

% Grab the a* channel
Ilab = applycform(I,c);
G = 1-mat2gray(Ilab(:,:,2));
% keep the brightest pixels
Gimg = G>prctile(G(:),98);
Gimg = bwareaopen(Gimg,ceil(0.05*max(s)));
% save the image prior to dilation
GpreDil = Gimg;
% continue morphological ops for extracting the rope
Gimg = bwmorph(Gimg,'dilate',ceil(0.05*max(s)));
Gimg = bwareaopen(Gimg,ceil(0.004*max(s)^2));

% complete broken rope with a linear filter.
horzFilt = strel('line',50,0);
vertFilt = strel('line',30,90);

% 
ropeMask = imclose(Gimg,horzFilt);
ropeMask = imclose(ropeMask,vertFilt);

[imageSections,~] = bwlabel(~ropeMask);
stats = regionprops(imageSections,'All');
bigSection = find([stats.Area]==max([stats.Area]));

% This is the mask of the region of interest
coralMask = imageSections==bigSection;
% but it's too conservative, so dilate again.
sumVal = max(coralMask(:));
curMask = coralMask;
n = 1;
while sumVal == 1
    curMask =  bwmorph(curMask,'dilate',1);
    sumVal = max(max(GpreDil + curMask));
    n = n+1;
end

coralMask = imresize(bwmorph(coralMask,'dilate',n-3),[sor(1) sor(2)]);
ropeMask = imresize(ropeMask,[sor(1) sor(2)]);






