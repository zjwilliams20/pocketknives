function checksum = genChecksum(varargin)
%GENCHECKSUM arbitrary checksum generation; creates a number unique to a
%            set of inputs consistent across calls via recursion
% checksum = genChecksum(varargin)
% AUTHOR: Zach Williams

MOD = 999931;
MULT = 977;
checksum = 0;

for iArg = 1:numel(varargin)
    
    arg = varargin{iArg};
    addend = 0;
    
    if isstruct(arg)
        argCell = struct2cell(arg);
        addend = addend + genChecksum(argCell{:});
    elseif isinf(arg)
        addend = iArg * MULT^2;
    elseif isnumeric(arg)
        [~, factors] = num2si(arg);
        addend = sum(int64(arg .* factors), 'all');
    elseif ischar(arg)
        addend = sum(int64(arg), 'all');
    else
        addend = iArg * MULT;
    end
    
    checksum = checksum + iArg * MULT * addend;
end

checksum = mod(checksum, MOD);

assert(isscalar(checksum))

end

