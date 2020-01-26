function [ labelImage ] = avoidLeakage( long_conts_map, roughImage )
    [N1, N2]=size(roughImage);
    labelImage = zeros(N1, N2);
    %% Seperate Region with the Same Clustering Label
    initialClass = unique( roughImage(:));
    tempConn = arrayfun( @(x) bwconncomp( roughImage==x,8), initialClass, 'UniformOutput', false);
    tempConn = [tempConn{:}];
    tempConn = {tempConn(:).PixelIdxList};
    tempConn = cat(2, tempConn{:})';

    for i = 1 : size(tempConn, 1)
        labelImage(tempConn{i})=i;
    end
    %% Disconnect the leakage part
    initialClass = size(tempConn, 1);
    [ longr, longc ] = find( long_conts_map );
    for i = 1 : size(tempConn, 1)
        tempImage = labelImage==i;
        tempRemoveLongCont = tempImage&~long_conts_map;
        tempConn = bwconncomp( tempRemoveLongCont,4);
        if tempConn.NumObjects>1
            for k = 1 : tempConn.NumObjects
                if numel(tempConn.PixelIdxList{k})>30
                    initialClass = initialClass+1;
                    labelImage(tempConn.PixelIdxList{k})=initialClass;
                end
            end
        end
    end
    %% join Long Contour pixel to the body
    sizeOfSp = arrayfun(@(x) numel( find(labelImage==x ) ), 1:max(labelImage(:)), 'UniformOutput', false );
    sizeOfSp = [sizeOfSp{:}];
    tempImage = labelImage;
    for i = 1 : numel(longr)
        neighbor = [ longr(i)+1,longc(i); longr(i)-1, longc(i); longr(i), longc(i)+1; longr(i), longc(i)-1; longr(i)-1, longc(i)-1; longr(i)+1, longc(i)+1; longr(i)+1, longc(i)-1; longr(i)-1, longc(i)+1 ];
        y = neighbor(:,1)<1 | neighbor(:,2)<1 | neighbor(:,1)>N1 | neighbor(:,2)>N2;
        neighbor(y,:)=[];
        neighbor = neighbor(:,1)+(neighbor(:,2)-1)*N1;
        neighborClass = unique( labelImage(neighbor) ) ;
        tempImage(longr(i)+(longc(i)-1)*N1 ) = neighborClass( find( sizeOfSp( neighborClass )  == max( sizeOfSp( neighborClass ) ), 1) );
    end
    labelImage = tempImage;
    labelImage = sortRefindIndex(labelImage);
end

