function outImg = fixSubtractionArtifacts(inImg)

% This script identifies if there are any subtraction artifacts by checking
% intensity gradient on the boundaries of the image. If any are found,
% those pixels are set to zero. Artifacts generally look like bands of
% brighter pixels on the boundaries. If we don't remove these artifacts, some of the
% other functions that operate based on intensity can error out.

% inImg is the RGB input image
% outImg is the same as inImg, except pixels with subtraction artifacts (if
% found)have been set to zero

% Size of the image
s = size(inImg);

% Convert the RGB image to grayscale
Ig = rgb2gray(inImg);

% d is a buffer from the edges in which we will search for artifacts
d = ceil(0.03*s(1));

% initialize a mask which labels each corner of the image.
mask = zeros(s(1),s(2));

% Label each corner of the image
mask(:,1:d) = 1;
mask(1:d,:) = 2;
mask(:,end-d:end) = 3;
mask(end-d:end,:) = 4;

% initialize the artifact mask
artifactMask = zeros(s(1),s(2));

% Top of image, mask ==2
curImg = double(Ig).*double(mask==2);
artifactMask = getSumAlongBorder(curImg,2,2,artifactMask);

% Bottom of image, mask ==4
curImg = double(Ig).*double(mask==4);
artifactMask = getSumAlongBorder(curImg,2,4,artifactMask);

% Left of image, mask ==1
curImg = double(Ig).*double(mask==1);
artifactMask = getSumAlongBorder(curImg,1,1,artifactMask);

% Right of image, mask ==3
curImg = double(Ig).*double(mask==3);
artifactMask = getSumAlongBorder(curImg,1,3,artifactMask);

% Output image with the artifacts blacked out
outImg = inImg;
for j = 1:3
    thisLayer = double(inImg(:,:,j));
    outImg(:,:,j) = uint8(thisLayer.*~artifactMask);
end


end

function outMask = getSumAlongBorder(curImg,n,d,outMask)
% This function sums the pixel intensities along the image border and
% checks for discontinuities

sumVal = sum(curImg,n);
sumVal(sumVal==0) = [];
diffVal = abs(diff(sumVal));
[pks,locs] = findpeaks(diffVal,'threshold',800);

if ~isempty(locs)% there is an intensity gradient
    if numel(locs)>1
        % Find the biggest peak
        maxInd = (pks==max(pks));
        locs(~maxInd) = [];
    end
    if d ==1
        outMask(:,1:locs) = 1;
    elseif d== 2
        outMask(1:locs,:) = 1;
    elseif d==3
        m = abs(length(sumVal)-locs);
        outMask(:,end-m:end) = 1;
    elseif d==4
        m = abs(length(sumVal)-locs);
        outMask(end-m:end,:) = 1;
    end
    
end
end


