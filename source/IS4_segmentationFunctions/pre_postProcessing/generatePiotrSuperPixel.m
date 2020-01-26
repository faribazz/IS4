function [ Is_int ] = generatePiotrSuperPixel( image )
    % load pre-trained edge detection model and set opts (see edgesDemo.m)
    model=load( fullfile( pwd, 'source', 'IS4_segmentationFunctions', 'StructuredEdgeDetection', 'release', 'models' ,'forest', 'modelBsds.mat')); 
    model=model.model;
    model.opts.nms=-1;
    model.opts.nThreads=4;
    model.opts.multiscale=0;
    model.opts.sharpen=2;
    % set up opts for spDetect (see spDetect.m)
    opts = spDetect();
    opts.nThreads = 4;  % number of computation threads
    opts.k = 1000;       % controls scale of superpixels (big k -> big sp)%5000
    opts.alpha = .5;    % relative importance of regularity versus data terms
    opts.beta = .9;     % relative importance of edge versus color terms
    opts.merge = 0;     % set to small value to merge nearby superpixels at end
    %
    loadSpParameters( ); % Load Sp parameters
    [edgeMap,~,~,~]=edgesDetect(image,model);
    [S,~] = spDetect(image,edgeMap,opts); % Algorithm dollar
    [h,w,~]=size(image);
    Is_int = double( S );
    [~, ~, ic] = unique(reshape(Is_int, h*w, 1));
    Is_int = reshape(ic, h, w);   
    sp_amount = max(Is_int(:));

    sp_counter = 0;
    for k = 1:sp_amount
        CC = bwconncomp(logical(Is_int == k)); 
        for u = 2:CC.NumObjects
            ch = CC.PixelIdxList{u};
            sp_counter = sp_counter + 1;
            Is_int(ch) = sp_amount + sp_counter; 
        end
    end
    Is_int = joinLessThan10(Is_int,10);
    Is_int= sortRefindIndex(Is_int);
end

