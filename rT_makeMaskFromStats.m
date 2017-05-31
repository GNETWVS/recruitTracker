function mask = rT_makeMaskFromStats(stats,s)


mask = zeros(s(1)*s(2),1);

for i = 1:numel(stats)
    curBlob = stats(i). PixelIdxList;
    mask(curBlob) = 1;
end
mask = reshape(mask,[s(1) s(2)]);