function outImg = orientImageConsistently(inImg)

% We want all our images in Landscape format, with the rectangle the rope
% makes facing down. Because this is the direction the diver took the photo
% in.

% First, make the image Landscape.
I = rotateImage(inImg);
s = size(I);

% Now we have to determine whether to flip it upside down or not.
Ig = rgb2gray(I);

% Calculate the column sum
sumRows = sum(Ig,2);

% midpoint of the image (horizontal line across)
mp = ceil(s(1)/2);

% is the horizontal peak before or after the midpoint?
[pks,locs] = findpeaks(sumRows);
maxLoc = locs(find(pks==max(pks)));

if maxLoc >= mp
    outImg = imrotate(I,180);
else
    outImg = I;
end

