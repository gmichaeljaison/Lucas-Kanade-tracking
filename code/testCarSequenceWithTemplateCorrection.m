% testCarSequenceWithTemplateCorrection.m
% refer: https://www.ri.cmu.edu/pub_files/pub4/matthews_iain_2003_2/matthews_iain_2003_2.pdf

load('../data/carseq.mat');
rects_nrml = load('carseqrects.mat'); % rect without auto correction
rects_nrml = rects_nrml.rects;

createPoly = @(rect) [rect(1), rect(2), rect(3)-rect(1), rect(4)-rect(2)];

nFrames = size(frames, 3);

framesToCapture = [1 100 200 300 400];
width = size(frames,2);
oImgs = zeros(size(frames,1), width * length(framesToCapture), 3);
rects = zeros(nFrames, 4);

% initial car position
rect = [60, 117, 146, 152];
t1 = warpTranslation(im2double(frames(:,:,1)), rect, [0,0]);

for i = 1 : nFrames-1
    tmpl = warpTranslation(im2double(frames(:,:,i)), floor(rect), [0,0]);
    It1 = im2double(frames(:,:,i+1));
    
    nIter = 1;
    while (nIter < 50)
%         compute Pn using Pn-1
        [u,v] = LucasKanade(tmpl, It1, floor(rect));
        rect = rect + [u, v, u, v];
        
%         compute Pn* (with template1)
        [u1,v1] = LucasKanade(t1, It1, floor(rect));
        rect = rect + [u1, v1, u1, v1];
        
        if (norm([u,v]) - norm([u1,v1]) <= 0.1)
            break;
        end
        
    end
    
    rects(i,:) = rect;
    
%     imshow(It1);
    poly = createPoly(rect);
    rectangle('Position', poly);
    
    idx = find(framesToCapture == i);
    if (idx)
        sIdx = width * (idx-1);
        It1 = insertShape(It1, 'Rectangle', poly, 'Color', 'yellow', 'LineWidth', 2);
        It1 = insertShape(It1, 'Rectangle', createPoly(rects_nrml(i,:)), ...
            'Color', 'green', 'LineWidth', 2);
        
        oImgs(:, sIdx+1 : sIdx+width, :) = It1;
    end
    
%     pause(0.001);
end

imshow(oImgs);
save('carseqrects-wcrt.mat', 'rects');
