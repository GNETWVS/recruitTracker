function pixToCM = rT_getPix2CMratio(inImg,ropeMask,resizeFactor)
% In this function, to calculate pixel to CM conversion, we look for the markings on the rope, which are all 1
% cm apart. We find all markings, and then look at the frequency of their
% spacing. The highest frequency should be those 1 cm marks.

% Green channel of the image has the strongest signal
G = double(inImg(:,:,2));

% Clear out everything except for the rope area
Gmasked = uint8(G.*double(ropeMask));

% Calculate pixel sums in the 1st direction
diffs1 = getDistanceDistribution(Gmasked,1);

% Calculate pixel sums in the 2nd direction
diffs2 = getDistanceDistribution(Gmasked,2);

% Combine found spacings from both image dimensions - since the horizontal
% and vertical segments of the rope are the same, and roughly on the same
% plane relative to the camera
diffsCombined = [diffs1(:);diffs2(:)];
[N,edges] = histcounts(diffsCombined,20);
maxVal = find(N==max(N));
% The pixel to CM conversion ratio for this image is the average of the
% values in the most crowded bin
pixToCM = floor(0.5*(edges(maxVal) + edges(maxVal + 1)));

% In case the code doesn't correctly identify the ropes, we can use te
% approximate value for our dataset. This should be modified if a different
% dataset is used.
if (numel(pixToCM)>1)  % if more than one found, pick the closest to the correct value
    ideal_pixToCM = 250*resizeFactor;
    d = pixToCM-ideal_pixToCM;
    if (abs(min(d)-ideal_pixToCM)<=0.1*ideal_pixToCM)
        ind = find(d==min(d));
        pixToCM(~ind) = [];
    else
        pixToCM = 250*resizeFactor;
    end
else
    if (pixToCM > 1.1*resizeFactor*250)
        pixToCM = 250*resizeFactor;
    end
end

end

function diffs1 = getDistanceDistribution(Gmasked,num)
numPix = numel(Gmasked);
sum1 = -sum(Gmasked,num);
sum1 = sum1 - mean(sum1);
sum1(sum1<0) = 0;
[~,locs1,~] = findpeaks(sum1,'minpeakdistance',floor(0.002*numPix/100));
diffs1 = locs1(2:end)-locs1(1:end-1);
end
