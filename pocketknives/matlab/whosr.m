function whosr(varName, level, width, last, truncated)
%WHOSR recursive whos printing
% INPUTS:
%   varName: char vector for name of variable in caller's workspace
%   level (internal): specifies number of indents
%   width (internal): specifies width of variable names at this level
%   last (internal): specifies whether we're on the last variable
%   truncated (internal): specifies whether we truncated this level's fields
% AUTHOR: Zach Williams

arguments
    varName (1,:) char = ''
    level (1,1) double = 0
    width (1,1) double = 0
    last (1,1) logical = false
    truncated (1,1) logical = false
end

INF_RECURSIVE_CLASSES = {'matlab.ui.Figure', 'py.int', 'py.numpy.ndarray', ...
    'matlab.graphics.'};

MAX_RECURSIONS = 10;
assert(level <= MAX_RECURSIONS)

% retrieve information about requested variable in parent workspace
varInfo = evalin('caller', sprintf('whos(''%s'')', varName));

% print the user's variable
if strlength(varName) > 0
    varData = evalin('caller', varName);
    
% when user doesn't specify a variable, print the entire workspace
else
    assert(level == 0)
    width = max(cellfun(@strlength, {varInfo.name}));

    for iVar = 1:numel(varInfo)
        varName = varInfo(iVar).name;
        varData = evalin('caller', varName); %#ok<NASGU>
        eval([varName ' = varData;'])
        whosr(varName, level, width)
    end
    return
end

% cut the call stack when data isn't present
if isempty(varInfo) || isempty(varData)
    return
end

try
    fields = fieldnames(varData);
    
    % remove table specific meta-data
    fields = fields(~ismember(fields, {'Properties', 'Row', 'Variables'}));

% should catch for most types besides struct & user classes
catch
    printVar(varInfo, level, width, last, truncated)
    return
end

% determine whether we need to stop the recursion
quitPython = ~isempty(strfind(varInfo.class, 'py.')) && level > 1;
isRecursiveClass = ismember(varInfo.class, INF_RECURSIVE_CLASSES) || ...
    contains(varInfo.class, INF_RECURSIVE_CLASSES);
if isempty(fields) || isRecursiveClass || quitPython
    printVar(varInfo, level, width, last)
    return
end

% otherwise print all fields of variable
assert(isscalar(varInfo))
printVar(varInfo, level, width, last, truncated)
printFields(varData, fields, level)

end


function printFields(varData, fields, level)
%PRINTVARS print a variable with one or more fields recursively

arguments
    varData %#ok<INUSA>
    fields cell
    level (1,1) double
end

width = max(cellfun(@strlength, fields));

MAX_NFIELDS = 30;
nFields = min(numel(fields), MAX_NFIELDS);

truncated = false;
fieldInd = 1:nFields;
if nFields ~= numel(fields)
    truncated = true;
    fieldInd = [fieldInd numel(fields)];
end

for iF = fieldInd
    fieldname = fields{iF};
    try
        eval([fieldname ' = varData.(fieldname);'])
    catch ME
        disp(ME)
        keyboard % fixme
    end
    whosr(fieldname, level+1, width, iF == numel(fields), truncated)
end

end


function printVar(varInfo, level, width, last, truncated)
%PRINTVAR print meta-data for a variable

arguments
    varInfo (1,1) struct
    level (1,1) double
    width (1,1) double
    last (1,1) logical = false
    truncated (1,1) logical = false
end

if numel(varInfo.size) > 2
    warning("Only printing variables with dimensions <= 2")
end

if level
    whitespace = repmat(sprintf('\t'), level, 1);
    if ~last
        fprintf('%s╠═ ', whitespace)
    else
        if truncated
            fprintf('%s⋮\n', whitespace)
        end
        fprintf('%s╚═ ', whitespace)
    end
end

nBytes = varInfo.bytes;
fprintf('%-*s\t%+10ux%-10u\t%+6s\t%-14s\n', width, varInfo.name, ...
    varInfo.size(1), varInfo.size(2), num2si(nBytes), varInfo.class)

end
