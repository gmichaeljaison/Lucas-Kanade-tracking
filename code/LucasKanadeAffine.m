function [ M ] = LucasKanadeAffine( It, It1 )
% refer: http://www.ri.cmu.edu/pub_files/pub3/baker_simon_2002_3/baker_simon_2002_3.pdf

% M: affine transformation matrix
%     six params for affine transformation [1+a b c; d 1+e f]
    M = eye(3);
    template = It;
    
    
    [SDI, H] = hessian(template);
    
    nIter = 1;
    while (nIter < 100)

    %     1. warp T: T -> W(T)
        imgWarped = warp(template, M);
        
    %    find the error only in the overlapping area (common area)
        [h, w] = size(template);
    %     find the 4 corners of img2
        c = [1 1 1;  w 1 1; w h 1; 1 h 1]';
        cH = M * c;
        
        xstart = ceil(max(1, max(cH(1,1), cH(1,4))));
        xend = floor(min(w, min(cH(1,2), cH(1,3))));
        ystart = ceil(max(1, max(cH(2,1), cH(2,2))));
        yend = floor(min(h, min(cH(2,3), cH(2,4))));

    %     2. error: E = I - W(T)
        error = zeros(size(template));
        error(ystart:yend, xstart:xend) = It1(ystart:yend, xstart:xend) - ...
            imgWarped(ystart:yend, xstart:xend);
        
        
    %     7. compute deltaP
        dP = H \ (SDI' * error(:));

    %     7. update P
        dW_inv = invWarpM(dP);
%         dW_inv = inv(warpM(dP));
        M = composeWarp(M, dW_inv);
        
%         exit condition
        if (norm(dP) < 0.1)
            break;
        end
        nIter = nIter + 1;
    end
    
end

function [SDI, H] = hessian(template)

%     3. Evaluate gradient of T(x)
    [dIx, dIy] = gradient(template);
    
%     4. Jacobian - Jacobian for affine transformation is [x 0 y 0 1 0; 0 x 0 y 0 1]
%     5. compute steepest descent images = dI * J
    m = size(template,1);
    n = size(template,2);
    [X,Y] = meshgrid(1:n, 1:m);
    X = X(:);
    Y = Y(:);
    J = repmat([X Y ones(m*n,1)],1,2);
    dI = [repmat(dIx(:),1,3) repmat(dIy(:),1,3)];
    SDI = dI .* J;

%     6. compute Hessian
    H = SDI' * SDI;
end

function [M]  = warpM(p)
    M = [reshape(p, [3,2]).'; 0 0 0];
    M = eye(3) + M;
end

function [M] = invWarpM(p)
    newP = zeros(size(p));
    
    p = [p(1) p(4) p(2) p(5) p(3) p(6)];
    
    den = (1+p(1)) * (1+p(4)) - p(2) * p(3);
    newP(1) = -p(1) - p(1)*p(4) + p(2)*p(3);
    newP(4) = -p(2);
    newP(2) = -p(3);
    newP(5) = -p(4) - p(1)*p(4) + p(2)*p(3);
    newP(3) = -p(5) - p(5)*p(4) + p(6)*p(3);
    newP(6) = -p(6) - p(1)*p(6) + p(2)*p(5);
    newP = newP / den;
    
    M = warpM(newP);
end

function [p] = getP(M) 
    M = M - eye(3);
    
    p = reshape(M', [], 1);
    p = p(1:6);
    p = [p(1) p(4) p(2) p(5) p(3) p(6)];
end

function [M] = composeWarp(M1, M2)
    newP = zeros(size(6,1));
    
    p1 = getP(M1);
    p2 = getP(M2);
    
    newP(1) = p1(1) + p2(1) + p1(1)*p2(1) + p1(3)*p2(2);
    newP(4) = p1(2) + p2(2) + p1(2)*p2(1) + p1(4)*p2(2);
    newP(2) = p1(3) + p2(3) + p1(1)*p2(3) + p1(3)*p2(4);
    newP(5) = p1(4) + p2(4) + p1(2)*p2(3) + p1(4)*p2(4);
    newP(3) = p1(5) + p2(5) + p1(1)*p2(5) + p1(3)*p2(6);
    newP(6) = p1(6) + p2(6) + p1(2)*p2(5) + p1(4)*p2(6);
    
    M = warpM(newP);
end
