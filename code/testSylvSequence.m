load('../data/sylvseq.mat');
load('../data/sylvbases.mat');

nFrames = size(frames, 3);

framesToCapture = [1 200 300 350 400];
width = size(frames,2);
oImgs = zeros(size(frames,1), width * length(framesToCapture), 3);

rect = [102,62,156,108];

for i = 1 : nFrames-1
    It = im2double(frames(:,:,i));
    It1 = im2double(frames(:,:,i+1));
    
    [u,v] = LucasKanadeBasis(It, It1, floor(rect), bases);
%     [u,v] = LucasKanade(It, It1, floor(rect));
    
    rect = rect + [u, v, u, v];
    
    imshow(It1);
    poly = [rect(1), rect(2), rect(3)-rect(1), rect(4)-rect(2)];
    rectangle('Position', poly);
    
    idx = find(framesToCapture == i);
    if (idx)
        sIdx = width * (idx-1);
        It = insertShape(It, 'Rectangle', poly, 'Color', 'yellow');
        oImgs(:, sIdx+1 : sIdx+width, :) = It;
    end
    
    pause(0.00001);
end