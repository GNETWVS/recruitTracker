function adj = rT_adjust(work,val,flag,percen,maxCol)

% params are im, gamma, flag (1 to use stretchlim)
if nargin == 2
    flag=1;
    percen=[0.001 0.999];
    maxCol=[1 1 1];
elseif (nargin == 3)
    percen=[0.001 0.999];
    maxCol=[1 1 1];
elseif (nargin == 4)
    maxCol=[1 1 1];
end

% Scale the image
work = work-min(work(:));
work = work./max(work(:));

minw = min(min(work));
minw = minw(:);
maxw = max(max(work));
maxw = maxw(:);
% Added by Derya
maxw = maxw + 0.00001;
maxw(maxw>1) = 1;

if flag==3
    s = size(work); work = work(:); flag = 1;
end

if flag==1
    if(size(work,3)==3)
        adj=imadjust(work,stretchlim(work,percen),[0 0 0; maxCol],val);
    else
        adj=imadjust(work,stretchlim(work,percen),[],val);
    end
    
elseif flag==2
    if(size(work,3)==3)
        adj=imadjust(work,[minw'; maxw'],[0 0 0; maxCol],val);
    else
        adj=imadjust(work,[minw'; maxw'],[0 ; 1],val);
    end
end
if (size(adj,2)==1)
    adj=reshape(adj,s);
end
