load('../data/aerialseq.mat');

nFrames = size(frames, 3);
framesToCapture = [30,60,90,120];
width = size(frames,2);
oImgs = zeros(size(frames,1), width * length(framesToCapture), 3);

fig1 = figure(1);
fig2 = figure(2);

for i = 1 : nFrames-1
    It = im2double(frames(:,:,i));
    It1 = im2double(frames(:,:,i+1));
    
    mask = SubtractDominantMotion(It, It1);
    
    im = imfuse(It1, mask);
    figure(fig1); imshow(im);
    
    
    idx = find(framesToCapture == i);
    if (idx)
        sIdx = width * (idx-1);
        oImgs(:, sIdx+1 : sIdx+width, :) = im;
        
%         figure(fig2); imshow(oImgs);
    end
    
    pause(0.0001);
end