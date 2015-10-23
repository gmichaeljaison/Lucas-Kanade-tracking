function [warpI] = warp(I, M)

%     warpI = imwarp(I, affine2d(M'));

    fill_value = 0;
    out_size = [240 320];
    tform = maketform( 'affine', M'); 
    warpI = imtransform( I, tform, 'bilinear', ...
        'XData', [1 out_size(2)], 'YData', [1 out_size(1)], ...
        'Size', out_size(1:2), ...
        'FillValues', fill_value*ones(size(I,3),1));

end