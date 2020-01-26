function [ spParameter ] = loadSpParameters( )
    spParameter.seg_method = 'slic';
    spParameter.slic_regularizer = 800; % default 800
    spParameter.slic_region_size =20; % default 20
    %% Features
    spParameter.diagonal_connections = 1; % default 0. Whether only diagonally connected pixels are considered connected.
    % Histogram features to use
    spParameter.feature_dsift_bow = 0;    % 1 % denseSIFT bag-of-words
    spParameter.feature_color_bow = 0;    % 2 % color bag-of-words in various color spaces
    spParameter.feature_rgb_raw = 1;      % 3 % raw rgb histograms
    spParameter.feature_grad_texture = 0; % 4 % feature used by van de Sande. Has two implementations, see code
    spParameter.feature_lbp = 0;          % 6 % Local binary patterns
    spParameter.feature_size = 1;         % 8 % size of combined superpixel
    spParameter.collect_merged_regions = 1; % default 1. Every time a pair is merged during the greedy pairing algorithm, the new pair is saved as a region
    spParameter.gc_branches = 15; % default 15. Number of graphcut branches.
    spParameter.start_phase2 = 0.8; % 0.8 default. Score at which to change features and/or start branching
end

