function [ finalClass ] = getRoughImagefromSp( initialSp, idx, N1, N2 )
    finalClass = zeros(N1, N2);
    for i = 1 : numel(initialSp)
        spIndex = initialSp{i}.index;
        finalClass(spIndex) = idx(i);
    end
end

