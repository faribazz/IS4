function [ labelImage ] = bwLabelNewLabelImage( roughImage )
    labelImage = zeros(size(roughImage,1), size(roughImage,2));
    initialClass = unique( roughImage(:));
    tempConn = arrayfun( @(x) bwconncomp( roughImage==x,4), initialClass, 'UniformOutput', false);
    tempConn = [tempConn{:}];
    tempConn = {tempConn(:).PixelIdxList};
    tempConn = cat(2, tempConn{:})';
    for i = 1 : size(tempConn, 1)
        labelImage(tempConn{i})=i;
    end
end

