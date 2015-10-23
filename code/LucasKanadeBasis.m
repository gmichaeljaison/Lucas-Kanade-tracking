function [ u,v ] = LucasKanadeBasis( It, It1, rect, bases )
%   consider bases as params like u,v

    p = [0; 0; zeros(size(bases,3),1)];
    bases2d = reshape(bases, size(bases,1)*size(bases,2), size(bases,3));
    
    template = warp(It, rect, p);
    
    [dIx, dIy] = gradient(double(It1));
    
    nIter = 1;
    while (nIter < 100)

    %     1. warp I: I -> I(W)
%         imgWarped = warp(It1, rect, p);
        imgWarped = warp(It1, rect, p);

    %     2. error: E = T - I(W)
        error = template - imgWarped;

    %     3. Warp gradient of I to compute dI
        dIx_p = warp(dIx, rect, p);
        dIy_p = warp(dIy, rect, p);

        dI = [dIx_p(:), dIy_p(:), bases2d];

    %     4. Jacobian - Jacobian for translation(u,v) is [1 0; 0 1]

    %     5. compute Hessian
        H = dI' * dI;

    %     6. compute deltaP
        E = double(error(:));
        dP = inv(H) * dI' * E;

    %     7. update P (p(1:2)=> (u,v), p(3:end) -> weights
        p = p + dP;
        
%         exit condition
        if (abs(sum(dP)) < 0.05)
            break;
        end
        nIter = nIter + 1;
    end
    
    u = p(1);
    v = p(2);
end

function [warpI] = warp(I, rect, p)
    [X,Y] = meshgrid(rect(1)+p(1):rect(3)+p(1), ...
        rect(2)+p(2):rect(4)+p(2));
    warpI = interp2(I, X, Y);
end
