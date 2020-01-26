function [bound_disp, color_disp ] = displayColorSeg(img, labels)
    [H, W, C] = size(img); 
    L = max(labels);
    labels = labels(1:H*W,1);
    bound_disp = img;
    labelImg = reshape(labels,H,W); 
    [~, ~, bound_disp]=segoutput(bound_disp, labelImg);
    color_disp = zeros(H, W, C);
    for i=1:L
        idx = find(labels==i);
        for j=1:C
            tmp = color_disp(:, :, j); tmp1 = img(:, :, j);
            tmp(idx) = mean(tmp1(idx)); 
            color_disp(:, :, j) = tmp; 
        end
    end
end

