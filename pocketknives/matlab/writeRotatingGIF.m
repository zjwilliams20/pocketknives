function writeRotatingGIF(gifname, delay, theta)
%WRITEROTATINGGIF rotate all 3D subplots in the current figure and write as GIF
% AUTHOR: Zach Williams

arguments
    gifname char
    delay (1,1) = 0.05
    theta (1,:) {issorted, mustBeInRange(theta, 0, 360)} = 1:360-1
end

children = findobj(gcf, 'Type', 'Axes');
ELEVATION = 15;

for itheta = 1:numel(theta)
    for ichild = 1:numel(children)
        subplot(children(ichild))
        view(theta(itheta), ELEVATION)
    end

    writeGIF(gifname, itheta, delay)
end

end