function factors = si2num(units)
%SI2NUM convert string vector of SI units to their corresponding factors, 
%       e.g. "n" --> 1e-9.
% AUTHOR: Zach Williams

arguments
    units (:,1) string {mustBeVector}
end

mapping = { ...
    'p', 1e-12
    'n', 1e-9
    'µ', 1e-6
    'm', 1e-3
    'k', 1e3
    'M', 1e6
    'G', 1e9
    'T', 1e12
    '',  1
};

nMappings = size(mapping, 1);
matchMask = false(nMappings, numel(units));
for iUnit = 1:numel(units)
    matchMask(:,iUnit) = strcmp(units(iUnit), mapping(:,1));
end

catchMask = cellfun(@isempty, mapping(:,1));
mask = matchMask | catchMask;
[~, matchInd] = maxk(mask, 1);

factors = cell2mat(mapping(matchInd, 2));
assert(isequal(size(factors), size(units)))

end