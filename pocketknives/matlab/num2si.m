function [xStr, factors, units] = num2si(x)
%NUM2SI convert numeric vector to string vector with units, e.g. 1e-9 ==> "1.0n"
% AUTHOR: Zach Williams

arguments
    x (1,:) {mustBeNumeric, mustBeVector}
end

nX = numel(x);

mapping = { ...
    @(x) 1e-15 <= x & x < 1e-9, 'p', 1e12
    @(x) 1e-9  <= x & x < 1e-6, 'n', 1e9
    @(x) 1e-6  <= x & x < 1e-3, 'µ', 1e6
    @(x) 1e-3  <= x & x < 1,    'm', 1e3
    @(x) 1e3   <= x & x < 1e6,  'k', 1e-3
    @(x) 1e6   <= x & x < 1e9,  'M', 1e-6
    @(x) 1e9   <= x & x < 1e12, 'G', 1e-9
    @(x) 1e12  <= x & x < 1e15, 'T', 1e-12
    @(x) true(1, nX),           '',  1
};

mapFunc = @(f, x) f(abs(x));
xCell = repmat({x}, size(mapping,1), 1);
mask = cell2mat(cellfun(mapFunc, mapping(:,1), xCell, 'UniformOutput', false));

factors = zeros(size(x));
[units, xStr] = deal(strings(size(x)));

for i = 1:nX
    ind = find(mask(:,i), 1);
    units(i) = mapping{ind, 2};
    factors(i) = mapping{ind, 3};
    xStr(i) = sprintf('%.4g%s', x(i) * factors(i), units(i));
end

end