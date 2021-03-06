function [ u,v ] = LucasKanadeBasis(template, It1, rect, bases )

    p = [0; 0];
    basesV = reshape(bases, [], size(bases,3));
    
%     3. Evaluate gradient of T(x)
    [dIx, dIy] = gradient(template);
    dI = [dIx(:) dIy(:)];
    
%     4. Jacobian - Jacobian for translation(u,v) is [1 0; 0 1]

%     5. compute steepest descent images = dI * J

%     6. compute Hessian
    H = dI' * dI;
    
    
    nIter = 1;
    while (nIter < 100)

    %     1. warp I: I -> I(W)
        imgWarped = warp(It1, rect, p);

    %     2. error: E = I(W) - T
        error = imgWarped - template;
        errorV = error(:);
        
%         find weights of bases and add with template.
        bWeights = errorV' * basesV;
        wBases = repmat(bWeights, size(basesV,1), 1) .* basesV;
        
        error = imgWarped(:) - template(:) - sum(wBases,2);

    %     7. compute deltaP
%         E = double(error(:));
        dP = H \ (dI' * error);

    %     7. update P
        p = p - dP;
        
%         exit condition
        if (norm(dP) < 0.05)
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
