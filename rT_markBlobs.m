function [n,coralStruct] = rT_markBlobs(fid,refImg,refMask,nextImg,nextMask,refStats,...
    nextStats,quadName,refImgName,nextImgName,n,coralStruct)

s = size(refMask);

refImgLabels = labelCoralsInImage(refMask,refStats);
nextImgLabels = labelCoralsInImage(nextMask,nextStats);

nRef = numel(refStats);
nNext = numel(nextStats);

fig = figure;
set(fig,'units','normalized')
set(fig,'outerPosition',[0 0 1 1])

p = uipanel('Position',[0 0.9 0.1 0.1]);
hold on

pDNE = uicontrol(p,'Style', 'pushbutton', 'String', 'Does Not Exist','units','normalized',...
    'Position', [0.1 0.1 0.7 0.7], 'Callback', @dneCallback);

pDNE.UserData = 0;

p1 = subplot(121);
%IdisplayRef = colorContours(refImg,refMask,[0 0 1]);
IdisplayRef = colorContours(refMask,[0 0 1]);

IdisplayRef = uint8(IdisplayRef) + uint8(255*refImgLabels);
imshow(refImg + IdisplayRef);
hold on

p2 = subplot(122);
IdisplayNext = colorContours(nextMask,[0 0 1]);

imshow(nextImg + uint8(IdisplayNext) + uint8(255*nextImgLabels));
hold on
drawnow

nUser = 0;


% Loop thru the blobs in the reference image
for k = 1:numel(refStats)
    n = n+1;
    curBlob = makeMaskFromStats(refStats(k),s);

    set(gcf,'currentAxes',p1)
    % Highlight the current blob
    imshow(refImg + uint8(IdisplayRef) + uint8(255*repmat(curBlob,[1 1 3])));
    % The user can click the middle of a coral, or click the button "DNE"
    set(gcf,'currentAxes',p2)
    t = waitforbuttonpress;
    uiwait(gcf,1);
    % This blob does not exist in image 2
    if t==0 | t==1
        if pDNE.UserData ==1
            blobNum = -999;
            pDNE.UserData = 0;
            x = NaN;
            y = NaN;
            
            % blob exists in image 2, ask the user to click on it
        else 
            
            [x,y] = ginput(1);
            % does this point correspond to any mask
            tempMask = zeros(s);
            tempMask(ceil(y),ceil(x)) = 100;
            blobNum = findBlobNumber(nextStats,tempMask);
            nUser = nUser + 1;
        end
    end
    

    % populate the file
    writeStr = [quadName,'\t',refImgName,'\t',num2str(k),'\t',nextImgName,'\t', num2str(blobNum),'\t',[num2str(ceil(x)),';',num2str(ceil(y))],'\n'];
    fprintf(fid,writeStr);

    coralStruct(n).quadName = quadName;
    coralStruct(n).refImgName = refImgName;
    coralStruct(n).refCoralNum = k;
    coralStruct(n).nextImgName = nextImgName;
    coralStruct(n).nextImgNum = blobNum;
    
end
close


% All blobs have been looped thru. Are there any in n+1 that weren't in
% image n?
% 
% if abs(nNext - nUser)>0
%     % which ones were those?
%     
% end


