function name = rT_writeFig(name,type)

% If not specified, we save a  png file
if (nargin==1)
    type = 'png';
end
I = getframe(gcf);
imwrite(I.cdata, [name '.' type],type);