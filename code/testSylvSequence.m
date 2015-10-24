load('../data/sylvseq.mat');
load('../data/sylvbases.mat');

nFrames = size(frames, 3);

framesToCapture = [1 200 300 350 400];
width = size(frames,2);
oImgs = zeros(size(frames,1), width * length(framesToCapture), 3);
rects = zeros(nFrames, 4);

rect = [102,62,156,108];
rect2 = rect;

for i = 1 : nFrames-1
    tmpl = warpTranslation(im2double(frames(:,:,i)), floor(rect), [0,0]);
    It1 = im2double(frames(:,:,i+1));
    
    [u,v] = LucasKanadeBasis(tmpl, It1, floor(rect), bases);
    
%     to compare with implementation without considering bases
    [u2,v2] = LucasKanade(tmpl, It1, floor(rect));
    
    rect = rect + [u, v, u, v];
    rects(i,:) = rect;
    
    rect2 = rect2 + [u2, v2, u2, v2];
    
%     imshow(It1);
    poly = [rect(1), rect(2), rect(3)-rect(1), rect(4)-rect(2)];
    poly2 = [rect2(1), rect2(2), rect2(3)-rect2(1), rect2(4)-rect2(2)];
    rectangle('Position', poly);
    rectangle('Position', poly2);
    
    idx = find(framesToCapture == i);
    if (idx)
        sIdx = width * (idx-1);
        It1 = insertShape(It1, 'Rectangle', poly, 'Color', 'yellow', 'LineWidth', 2);
        It1 = insertShape(It1, 'Rectangle', poly2, 'Color', 'green', 'LineWidth', 1);
        oImgs(:, sIdx+1 : sIdx+width, :) = It1;
    end
    
%     pause(0.00001);
end

imshow(oImgs);
save('sylvseqrects.mat', 'rects');

