
 function [ Out,Summed ] = mergeTrioPair(amb_im_path, white_im_path, fluo_im_path)
%  mergeTrioPair: Align a set of White, Fluoresence and Ambient image
%  Using SURF we allign fluorescent and ambient to white image.
%  Summed

% set debug to 1 if wanting do view intermediate steps
debug=0;
% Read the trio specified by the user
ambientImage = imread(amb_im_path);
whiteImage = imread(white_im_path);
fluoresenceImage = imread(fluo_im_path);

% Convert them to double and grayscale
ambientImgLinear = double(ambientImage);
fluroImgLinear = double(fluoresenceImage);
whiteImgLinear = double(whiteImage);

% Process the images non-linearly to enhance contrast
ambientImage = adjust(ambientImgLinear,0.55,2,[0.1 0.999]);
fluoresenceImage = adjust(fluroImgLinear,0.55,2,[0.1 0.999]);
whiteImage = adjust(whiteImgLinear,0.55,1,[0.1 0.999]);

ambientImageGray = rgb2gray(ambientImage);
whiteImageGray = rgb2gray(whiteImage);
fluoresenceImageGray = rgb2gray(fluoresenceImage);

% Use surf features to align ambient image and white image
points1 = detectSURFFeatures(ambientImageGray);
points2 = detectSURFFeatures(whiteImageGray);

[features1, valid_points1] = extractFeatures(ambientImageGray, points1);
[features2, valid_points2] = extractFeatures(whiteImageGray, points2);

indexPairs = matchFeatures(features1, features2,'Unique',true);
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);

% figure;showMatchedFeatures(A,W,matchedPoints1,matchedPoints2,'montage');

[tformaw ,~, ~] = estimateGeometricTransform(matchedPoints1,matchedPoints2,'projective');
amb = imwarp(ambientImgLinear,tformaw,'OutputView',imref2d(size(whiteImage)));

if debug
    figure; imshowpair(amb,whiteImage); title('Overlay Images');
end

% Detect surf features

points1 = detectSURFFeatures(fluoresenceImageGray,'NumOctaves',4, 'MetricThreshold',400,'NumScaleLevels',6 );
points2 = detectSURFFeatures(whiteImageGray,'NumOctaves',4,'MetricThreshold',400,'NumScaleLevels',6);
%disp('Extracting Features');
[features1, valid_points1] = extractFeatures(fluoresenceImageGray, points1);
[features2, valid_points2] = extractFeatures(whiteImageGray, points2);
%disp('Matching Features');

indexPairs = matchFeatures(features1, features2,'Unique',true);
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);

if debug
    figure;
    showMatchedFeatures(fluoresenceImage, whiteImage, matchedPoints1, matchedPoints2,'montage');
    title('before RANSAC');
end

[tformfw ,~ ,~] = estimateGeometricTransform(matchedPoints1,matchedPoints2,'projective','MaxNumTrials',10000,'Confidence',99.99);

% Warped fluorescent image
flr = imwarp(fluroImgLinear,tformfw,'OutputView',imref2d(size(whiteImage)));

if (debug)
    figure; showMatchedFeatures(fluoresenceImage, whiteImage, inlierpoints1, inlierpoints2,'montage');
    figure;imshowpair(Itf,whiteImage);
end;

% Subtracted image
R = subtractImagesRatio(flr,amb);

Out = flr-R*amb;
Summed = Out + whiteImgLinear;
Summed = adjust(Summed,1,3);
Out = Out/max(Out(:));

end

