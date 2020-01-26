function [sp, K] = update_sp_indexing(sp, K)
    counter = 1;
    sp_old = sp;
    sp = [];
    key = [];
    %% Build each superpixel
    for t = 1:length(sp_old)
        if size(sp_old{t}.index,1) > 0 
            sp{counter} = sp_old{t}; 
            key(end+1,1:2) = [t, counter]; 
            counter = counter + 1;
        end
    end
    %% Apply mapping to update sp labels
    K = arrayfun(@(x)key(key(:,1) == x, 2), K); 
    for t = 1:length(sp)
        sp{t}.neighbors = arrayfun(@(x)key(key(:,1) == x, 2), sp{t}.neighbors); 
    end
end
