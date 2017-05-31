function scaleImg = rT_placeScaleBar(I,pix2cm,resizeFactor,fontSizeVal)

s = size(I);
if nargin<4
    fontSizeVal = round(max(s(1),s(2))./30);
end


% make a mask the same size as the image
scaleImg = zeros(s(1),s(2));

% distance (in pixels) we want the scalebar to be from the bottom right edge of the
% image
d = ceil(s(1)*0.06);

% thickness of the scale bar (pixels)
th = ceil(d/3);

% make the scale bar
% left side of scale bar: 
L = s(2)-(pix2cm + d);
% Right side
R = s(2)-d;
% Top side
T = s(1)-d;
% Bottom side
B = T + th;
scaleImg(T:B,L:R) = 1;

% add the text to the image
scaleImg = insertText(scaleImg,[ceil(L-0.6*pix2cm),T-1.1*d],'1 cm','fontsize',fontSizeVal,'textcolor','blue','boxopacity',0);
