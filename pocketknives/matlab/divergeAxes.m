function divergeAxes(tag, axPos, newFig, varargin)
%DIVERGEAXES copy axes on current figure with tag or title onto new figure;
%            this passes remaining arguments to writeGIF.
% divergeAxes(tag, axPos, newfig, gifname)
% 
% NOTE:
%     Use: `subplot(n,m,i, 'Tag', 'mytag', 'NextPlot', 'add')` 
%     To make a subplot with a tag at creation that doesn't get killed
%     after you call plot. Kinda dumb if you ask me. Matplotlib doesn't
%     have that problem.
% AUTHOR: Zach Williams

arguments
    tag char
    axPos {mustBeNumeric, mustBeInRange(axPos, 0, 1)} = [] 
    newFig = []
end

arguments (Repeating)
    varargin
end

if isempty(axPos)
    % default axes position w/o subtitle
    axPos = [0.13 0.11 0.775 0.815];
    
    % w/ subtitle
    % axPos = [0.13 0.11 0.775 0.7809];
end

oldax = findobj(gcf, 'Tag', tag);

% try finding a subplot with that title
if isempty(oldax)
    oldaxes = findobj(gcf, 'Type', 'Axes');
    titles = get([oldaxes.Title], 'String');
    [isValidTitle, titleIdx] = ismember(tag, titles);
    assert(isValidTitle, 'Invalid Tag or title.')
    oldax = oldaxes(titleIdx);
end

if isempty(newFig)
    newFig = figure;
else
    figure(newFig)
end

% cla % messes up the ticks for some reason
clf % so just assume we only want one axes on the figure
newax = copyobj(oldax, newFig);
newax.Position = axPos;

if ~isempty(varargin)
    writeGIF(varargin{:})
end

% legend(legendUnq())

end