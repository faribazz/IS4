function [finalSegmentation] = main(image, parameters)
    %% Extracting Multi-layer Features
    [multiLayer, parameters] = extractingImageLayers(image, parameters); % Extracting input image layers
    localLayer = LSHextraction(multiLayer, parameters.ws); % Extracting LSH local features
    %% Preparing Dictionary Words using Nonnegative Matrix Factorization
    rng('default');
    idx = nnmfOrig(localLayer(:, [1:88, 155:155+87]), size(image,1), size(image,2), parameters.nseg, parameters.ws);
    aveSLocal = arrayfun(@(x) mean(localLayer(idx==x, :), 1), unique(idx(:)), 'UniformOutput' , false);
    aveSLocal = cat(1, aveSLocal{:});
    %% Initial Segmentation
    switch parameters.methodOfSegmentation
        case 'MCG'
            if ~exist(fullfile(parameters.mcgDir , strcat(parameters.fileName(1:end-4), '.mat')))
                error('Please choose another initial segmentation technique. MCG initial segmentation is only available for BSD500');
            else
                ucm2 = load(fullfile(parameters.mcgDir , strcat( parameters.fileName(1:end-4), '.mat')));
                labelsMCG = bwlabel(ucm2.ucm2 <= parameters.mcgThreshold);
                initialSegmentation = labelsMCG(2:2:end, 2:2:end);
            end
        case 'Piotr'
            initialSegmentation = generatePiotrSuperPixel(image);
        case 'Slic'
            initialSegmentation = double(vl_slic(single(image), 100, 5)) + 1;
    end
    %% IS4
    finalSegmentation = pre_IS4_optimization(image, initialSegmentation, multiLayer, localLayer, aveSLocal, parameters);
end