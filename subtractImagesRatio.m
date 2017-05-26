function [ ratio ] = subtractImagesRatio( flr, amb )
    
    [m n c] = size(flr);
    flr_cropped=flr(round(0.2*m):round(0.8*m),round(0.2*n):round(0.8*n),:);
    amb_cropped=amb(round(0.2*m):round(0.8*m),round(0.2*n):round(0.8*n),:);
    
    g1=mean2(flr_cropped(:,:,2));
    g2=mean2(amb_cropped(:,:,2));
    ratio=g1/g2;
    


    
    
    

end

