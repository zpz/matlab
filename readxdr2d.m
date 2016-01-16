function [data, validdata] = readxdr2d(filename, mask, irec);
% Read in utm or vtm data.

ndata = numel(find(mask == 1));

fid = fopen(filename);
fseek(fid, (irec - 1) * (ndata + 1) * 4 + 4, 'bof');
validdata = fread(fid, ndata, 'float32');

data = repmat(nan, size(mask, 2), size(mask, 1));
data(mask' == 1) = validdata;
data = data';

