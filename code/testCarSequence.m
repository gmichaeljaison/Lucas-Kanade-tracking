load('../data/carseq.mat');

nFrames = size(frames, 3);

framesToCapture = [1 100 200 300 400];
width = size(frames,2);
oImgs = zeros(size(frames,1), width * length(framesToCapture), 3);
rects = zeros(nFrames, 4);

% initial car position
rect = [60, 117, 146, 152];

for i = 1 : nFrames-1
    tmpl = warpTranslation(im2double(frames(:,:,i)), floor(rect), [0,0]);
    It1 = im2double(frames(:,:,i+1));
    
    [u,v] = LucasKanade(tmpl, It1, floor(rect));
    
    rect = rect + [u, v, u, v];
    rects(i,:) = rect;
    
%     imshow(It1);
    poly = [rect(1), rect(2), rect(3)-rect(1), rect(4)-rect(2)];
    rectangle('Position', poly);
    
    idx = find(framesToCapture == i);
    if (idx)
        sIdx = width * (idx-1);
        It1 = insertShape(It1, 'Rectangle', poly, 'Color', 'yellow', 'LineWidth', 2);
        oImgs(:, sIdx+1 : sIdx+width, :) = It1;
    end
    
%     pause(0.001);
end

imshow(oImgs);
save('carseqrects.mat', 'rects');
