load('../data/carseq.mat');

nFrames = size(frames, 3);

framesToCapture = [1 100 200 300 400];
width = size(frames,2);
oImgs = zeros(size(frames,1), width * length(framesToCapture), 3);

% initial car position
rect = [60, 117, 146, 152];

for i = 1 : nFrames-1
    It = im2double(frames(:,:,i));
    It1 = im2double(frames(:,:,i+1));
    
    
    [u,v] = LucasKanade(It, It1, floor(rect));
    
    rect = rect + [u, v, u, v];
%     rectF = floor(rect);
    
    imshow(It1);
    poly = [rect(1), rect(2), rect(3)-rect(1), rect(4)-rect(2)];
    rectangle('Position', poly);
    
    idx = find(framesToCapture == i);
    if (idx)
        sIdx = width * (idx-1);
        It = insertShape(It, 'Rectangle', poly, 'Color', 'yellow');
        oImgs(:, sIdx+1 : sIdx+width, :) = It;
    end
    
%     pause(0.1);
end
