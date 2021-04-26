function [r] =correlatevectors(a,b)
% Computes correlations (i.e., Spearman's R) between two vectors and deals
% with some specific issues

r=corr(a(:),b(:),'type','Spearman');

%   Deal with vectors less than two values to avoid NaN result
if length(unique(a))<2 || length(unique(b))<2
    r = 0;
end

end