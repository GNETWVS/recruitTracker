function I = rotateImage(I)
  % Rotate the image to be horizontal
  s = size(I);
  if s(1)>s(2)
      I = imrotate(I,90);
  end
end
