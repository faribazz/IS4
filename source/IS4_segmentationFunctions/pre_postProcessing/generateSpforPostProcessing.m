function [ sp, K, labelImage ] = generateSpforPostProcessing( labelImage )
    %% be tartib Lable Image
     availableClass = unique( labelImage(:) );
    sp=cell(numel( availableClass ), 1);
    %%
    for i = 1 : numel(availableClass)
        tempMat = labelImage==availableClass(i);
        sp{i}.index = find( tempMat );
        sp{i}.perimeter = sum(sum(tempMat & ~imerode(tempMat, se_disk(1))));
        tempDilate = imdilate(tempMat, se_disk(1));
        tempIndex = ( tempDilate & ~ tempMat );
        tempNeighor = unique( labelImage( tempIndex) );
        sp{i}.neighbors = tempNeighor( tempNeighor ~= i );
        sp{i}.dilateIndex = find(tempDilate);
        sp{i}.area = numel(sp{i}.index);
    end
    tempK = arrayfun(@(x) [ repmat( x, numel(sp{x}.neighbors), 1 ), sp{x}.neighbors ], 1:size(sp,1), 'UniformOutput', false);
    K = cat( 1, tempK{:});
    K = unique( sortrows(sort(K,2)), 'rows');
end

