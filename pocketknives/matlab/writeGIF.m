function writeGIF(gifname, isFirst, delay)
%WRITEGIF Write a GIF in the current loop on gcf
% INPUTS:
%     gifname: name of GIF file to write.
%     isFirst: whether this is the first iteration, assumed false.
%     delay: delta between frames.
% USAGE:
%     figure, hold on
%     for i = 1:20
%         stem(1:i, 'Color', 'b')
%         writeGIF('yee.gif', i==1, 1/10)
%     en
% AUTHOR: Zach Williams

arguments
    gifname char
    isFirst (1,1) logical = false
    delay (1,1) {mustBeNumeric} = 1
end

drawnow
frame = getframe(gcf);
im = frame2im(frame);

[A, map] = rgb2ind(im, 256);
if isFirst
    imwrite(A, map, gifname, 'gif', 'LoopCount', Inf, 'DelayTime', delay);
else
    imwrite(A, map, gifname, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
end

end

