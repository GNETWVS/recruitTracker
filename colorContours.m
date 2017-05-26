function coloredMask = colorContours(mask,color)

% Assumes nothing about the image onto which the contours will be overlaid

% If no color is specified, default to blue
if nargin<2
    color = [0 0 1];
end

% Get the boundaries of the found coral, ie mask.
s = size(mask);
boundaryMask = makeBoundaryMask(mask);
coloredMask  = zeros(s(1),s(2),3);

% Add the color for each blue.
for i = 1:3
    thisLayer = coloredMask(:,:,i);
    thisLayer(boundaryMask) = 255*color(i);
    coloredMask(:,:,i) = uint8(reshape(thisLayer,[s(1) s(2)]));
end
