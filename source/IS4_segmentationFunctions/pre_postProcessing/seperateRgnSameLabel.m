function [ labelImage ] = seperateRgnSameLabel( roughImage )
    %% Separate disjoint regions with the same clustering label
    initialClass = unique( roughImage(:));
    tempConn = arrayfun( @(x) bwconncomp( roughImage==x,8), initialClass, 'UniformOutput', false);
    tempConn = [tempConn{:}];
    tempConn = {tempConn(:).PixelIdxList};
    tempConn = cat(2, tempConn{:})';
    for i = 1 : size(tempConn, 1)
        labelImage(tempConn{i})=i;
    end
    labelImage = reshape(labelImage, size(roughImage));
end

