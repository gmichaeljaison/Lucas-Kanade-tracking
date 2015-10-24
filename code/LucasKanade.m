function [u,v] = LucasKanade(template, It1, rect)
% Lucas Kanade feature tracking implementation for translation alone
%  uses Inverse compositional approach
%  refer: http://www.ri.cmu.edu/pub_files/pub3/baker_simon_2002_3/baker_simon_2002_3.pdf

    p = [0; 0];
    
%     template = warp(It, rect, p);
    
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

    %     7. compute deltaP
        dP = H \ (dI' * error(:));

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
