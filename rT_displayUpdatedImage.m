function rT_displayUpdatedImage(inImg,labelMap,keepMask,rejectMask,keepColor,rejectColor,mask,processed,maskColor,processedColor)

% We will draw contours around all these blobs
if nargin>6
    overallMask = logical(keepMask) + logical(rejectMask) + logical(processed) + logical(mask);
else
    overallMask = logical(keepMask) + logical(rejectMask);
end
% Set these pixels in the image to zero, so the colors look OK
imgWithZeros = rT_setContoursToZero(inImg,overallMask);
% Get the relevant masks colored on the boundaries
if nargin > 6
    finalMask = rT_colorCodeCorals(keepMask,rejectMask,keepColor,rejectColor,mask,maskColor,processed,processedColor);
else
    finalMask = rT_colorCodeCorals(keepMask,rejectMask,keepColor,rejectColor);
end
% Show the image
imshow(imgWithZeros + uint8(255*finalMask) + uint8(255*labelMap))
drawnow