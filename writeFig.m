function name=writeFig(name,type)

if (nargin==1)
    type='png';
end
I = getframe(gcf);
imwrite(I.cdata, [name '.' type],type);