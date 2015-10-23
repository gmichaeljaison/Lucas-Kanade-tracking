function [ mask ] = SubtractDominantMotion( image1, image2 )

    M = LucasKanadeAffine(image1, image2);
    
    wImg1 = warp(image1, M);
    
    dImg = wImg1 - image2;
    
    mask = (dImg > 0.09);
    
    mask = bwareaopen(mask, 15);
    
    se = strel('diamond',8);
    mask = imdilate(mask, se);
    
    se = strel('disk', 4);
    mask = imerode(mask, se);

end

