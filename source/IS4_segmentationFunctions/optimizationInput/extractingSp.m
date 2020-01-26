function [ sp ] = extractingSp( initialSegmentation )
%% Extracting superpixels based on the inital segmentation
    maxLabels = unique(initialSegmentation(:));
    sp = cell( 1, numel( maxLabels ) );
    for j = 1 : numel(maxLabels)
        sp{j}.index = find( initialSegmentation(:) == maxLabels(j) );
    end
end

