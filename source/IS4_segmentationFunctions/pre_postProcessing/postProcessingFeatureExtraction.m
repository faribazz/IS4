function [ labelImage, sp, K ] = postProcessingFeatureExtraction( roughImage, long_conts_map, bdRatio, merge_TH  )
    %% BWLabel Kardane Sp ha
    [ roughImage ] = bwLabelNewLabelImage( roughImage );
    %% generateSp
    [ sp, K, labelImage] = generateSpforPostProcessing( roughImage );
    %% remove Fake Boundary
    longContourPixel = find(long_conts_map);
    diff_val= zeros( size(K,1), 1 );
    comm_val = zeros( size(K,1), 1 );
    for i = 1 : size(K,1)
        combndry = intersect( sp{K(i,1)}.dilateIndex, sp{K(i,2)}.dilateIndex );
        den = numel(combndry)/2;
        nom = intersect( combndry, longContourPixel );
        diff_val(i) = numel(nom)/den;
        comm_val(i) = den/min([ sp{K(i,1)}.perimeter, sp{K(i,2)}.perimeter]);
    end
    [~,order_idx] = sort(comm_val(:),'descend');
    comm_val = comm_val(order_idx);
    diff_val= diff_val(order_idx);
    K=K(order_idx, :);

    while numel( comm_val )>1
        i = 1;
        if comm_val(i)>bdRatio
            if diff_val(i) < merge_TH
                [ K, comm_val, diff_val, labelImage, sp ] = updateRemoveFakeBd( sp, K(i,:), K, comm_val, diff_val, labelImage, longContourPixel );
            else
                comm_val(i) = [];
                diff_val(i) = [];
                K(i,:)=[];
            end
        else
            comm_val(i) = [];
            diff_val(i) = [];
            K(i,:)=[];
        end
    end
    tempK = arrayfun(@(x) [ repmat( x, numel(sp{x}.neighbors), 1 ), sp{x}.neighbors ], 1:size(sp,1), 'UniformOutput', false);
    K = cat( 1, tempK{:});
    K = unique( sortrows(sort(K,2)), 'rows');
    y = K(:,1)==0 | K(:,2)==0;
    K(y,:)=[];
     [sp, K] = update_sp_indexing(sp, K);
     sp = sp';
end

