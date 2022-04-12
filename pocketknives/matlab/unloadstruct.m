function [varargout] = unloadstruct(s, varargin)
%UNLOADSTRUCT deal inputted struct fields into variable list from struct
% [varargout] = unloadstruct(s, varargin)
% AUTHOR: Zach Williams

arguments
    s (1,1) struct
end

arguments (Repeating)
    varargin
end

% Ensure all varargin are valid fields
assert(all(ismember(varargin, fieldnames(s))), ...
    'One or more field inputs not recognized in the input structure.')

% Deal varargout appropriately
nFields = numel(varargin);
varargout = cell(nFields, 1);
for iField = 1:nFields
    varargout{iField} = s.(varargin{iField});
end

end