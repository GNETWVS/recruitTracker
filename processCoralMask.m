function [keepMask,rejectMask,addedMask,stats,closeFlag,skipFlag] = processCoralMask(stats,keepMask,...
    pCheck,pCross,pDraw,pClose,pSkip,pEdit,pAutoOff,Idisplay,pNext,h_im,Ioriginal,resizeFactor)

% Flags for buttons
closeFlag = 0;
skipFlag = 0;
nextFlag = 0;

% Colors of boundaries we will display
% Blue for CURRENT mask
% White for already processed mask
% Green for automatically found masks, but not processed
% Magenta for rejected masks
maskColor = [0 0 1];
processedColor = [1 1 1];
keepColor = [0 1 0];
rejectColor = [1 0 1];

% Initialize various masks
s = size(keepMask);
addedMask = zeros(s); % manually added by the user
rejectMask = zeros(s(1),s(2)); % Outlines that were found automatically, which the user rejected.
processed = zeros(s(1),s(2)); % this is the list of corals user already processed.

% For the automatically found corals, we need to calculate labelMap only
% once. It might get updated if user manually draws corals later.
labelMap = labelCoralsInImage(keepMask,stats,resizeFactor);

% start looping through all blobs found and show them to the user
for kk = 1:numel(stats)
    % Add some fields that will be useful later.
    stats(kk).status = 'Automatically Found';
    stats(kk).keepStatus = 1; % keep;
    stats(kk).statusInd = 1; % numeric index for "found automatically"
    
    % mask of active coral - we will display this blue
    mask = makeMaskFromStats(stats(kk),s);
    % color code them for the user
    displayUpdatedImage(Idisplay,labelMap,keepMask,rejectMask,keepColor,rejectColor,mask,processed,maskColor,processedColor);
     
    % All buttons start unpressed for the user
    pCheck.UserData = 0;
    pCross.UserData = 0;
    pDraw.UserData = 0;
    pClose.UserData = 0;
    pEdit.UserData = 0;
    pSkip.UserData = 0;
    pNext.UserData = 0;
    pAutoOff.UserData = 0;
    
    % wait for the user to press a button
    k = waitforbuttonpress;
    
    uiwait(gcf);
    if k == 0
        % User clicks the KEEP button
        if logical(pCheck.UserData)
            processed = processed + mask;
            % User clicks the REJECT button
        elseif logical(pCross.UserData)
            rejectMask = rejectMask + mask;
            keepMask = keepMask - mask;
            stats = removeFromStats(stats,kk);
            % User clicks the CLOSE & SAVE button
        elseif logical(pClose.UserData)
            closeFlag = 1;
            break
            % User clicks the SKIP IMAGE button
        elseif logical(pSkip.UserData)
            skipFlag = 1;
            break
            % User clicks the EDIT BOUNDARY button
        elseif logical(pEdit.UserData)
            newMask = fineTuneBlobBoundaries(Ioriginal,resizeFactor,mask);
            keepMask = keepMask + newMask;
            stats = updateStats(stats,kk,newMask);
        elseif logical(pAutoOff.UserData)
            keepMask = zeros(s(1),s(2));
            rejectMask = zeros(s(1),s(2));
            processed = zeros(s(1),s(2));
            clear stats;
            labelMap = labelCoralsInImage(keepMask,1,resizeFactor);
            set(pCross,'enable','off')
            set(pCheck,'enable','off')
            break;
        end
    end
end
% Now the user has cycled all the automatically labeled ones, we give them
% the option to manually draw new ones

if exist('stats','var')
    if numel(stats)==0
        clear stats;
    end
end

if ~closeFlag & ~skipFlag
    % Refresh the contour color codes
    displayUpdatedImage(Idisplay,labelMap,keepMask,rejectMask,keepColor,rejectColor);
    
    % Enable buttons that were disabled before
    set(pDraw,'enable','on')
    set(pNext,'enable','on')
    % and disable others
    set(pCross,'enable','off')
    set(pCheck,'enable','off')
    set(pEdit,'enable','off')
    set(pAutoOff,'enable','off')
    
    % run this loop for manual drawing until the user clicks another button
    while ~nextFlag
        hAx = get(gcf,'currentAxes');
        k = waitforbuttonpress;
        uiwait(gcf);
        if k == 0
            if logical(pDraw.UserData)
                newMask = drawShape(hAx,h_im);
                if sum(newMask(:)) ~=0
                    addedMask = addedMask + newMask;
                    % current keepMask
                    keepMask = keepMask + newMask;
                    % stats updated
                    if ~exist('stats','var')
                        stats = createStats(newMask);
                    else
                        stats = addToStats(stats,newMask);
                    end
                    % update the legends
                    labelMap = labelCoralsInImage(keepMask,stats,resizeFactor);
                    displayUpdatedImage(Idisplay,labelMap,keepMask,rejectMask,keepColor,rejectColor);
                    % Clear the DRAW button
                    pDraw.UserData = 0;
                    % User clicks the CLOSE & SAVE button
                    
                else
                    pDraw.UserData = 0;
                end
                
            elseif logical(pClose.UserData) % closing out of the program, saving
                closeFlag = 1; if ~exist('stats','var'); stats = [];end;break
                % User clicks the SKIP IMAGE button
            elseif logical(pSkip.UserData)
                skipFlag = 1; if ~exist('stats','var'); stats = [];end;break
            elseif logical(pNext.UserData)
                nextFlag = 1;if ~exist('stats','var'); stats = [];end;
            end
        end
    end
end
end


function stats = addToStats(stats,newMask)

names = fieldnames(stats);
curNumStats = numel(stats);
curNum = curNumStats + 1;

tempStats = regionprops(logical(newMask),'All');

for j = 1:numel(names)
    curName = names{j};
    if strcmp(curName,'status')
        stats(curNum).(curName) = 'Manually Added';
    elseif strcmp(curName,'keepStatus')
        stats(curNum).(curName) = 1;
    elseif strcmp(curName,'statusInd')
        stats(curNum).(curName) = 2;
    else
        stats(curNum).(names{j}) = tempStats.(names{j});
    end
    
end

end


function stats = removeFromStats(stats,k)
stats(k).status = 'Manually Removed';
stats(k).statusInd = 3;
stats(k).keepStatus  = 0;
end

function stats = updateStats(stats,curNum,newMask)
names = fieldnames(stats);
tempStats = regionprops(logical(newMask),'All');

for j = 1:numel(names)
    curName = names{j};
    if strcmp(curName,'status')
        stats(curNum).(curName) = 'Manually Adjusted';
    elseif strcmp(curName,'keepStatus')
        stats(curNum).(curName) = 1;
    elseif strcmp(curName,'statusInd')
        stats(curNum).(curName) = 2;
    else
        stats(curNum).(names{j}) = tempStats.(names{j});
    end
    
end
end

function stats = createStats(newMask)

stats = regionprops(logical(newMask),'All');
stats.status = 'Manually Added';
stats.keepStatus = 1;
stats.statusInd = 2;
end


