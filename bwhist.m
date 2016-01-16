function [y, x] = bwhist(data, xrange, nbin, relative);
% Black/white histogram plot.
% Plot if no return value is requested,
% otherwise return the value without plotting.
% 
% DATA is a cell array with 1 or more (usually no more than 2) elements.
% Each element of DATA is either a column vector of data sample,
% or a 2-col matrix of empirical CDF, in which 
% the 1st col is Fy, and 2nd col is Fx.
%
% If XRANGE is not specified, plotted are
% NBIN bars uniformly located in the entire data range.
%
% If XRANGE is specified and has two elements, plotted are NBIN bars with center points
% uniformly located within XRANGE.
% If XRANGE is actually narrower than the data range,
% the first bar and last bar represent data at the two tails.
%
% If XRANGE has more than two elements,
% it specifies the midpoints of the bars.
%
% If any of the elements in DATA is a CDF function,
% RELATIVE must be true, or missing.
% Otherwise it can be true or false.
%
% Zepu Zhang
% 2004/09/11.
% 2005/09/19.


if nargin < 2 | isempty(xrange)
	xrange = [realmax, realmin];
	for i = 1 : length(data)
		xrange(1) = min(xrange(1), min(data{i}(:, end)));
		xrange(2) = max(xrange(2), max(data{i}(:, end)));
	end
end

if nargin < 3 | isempty(nbin)
	nbin = 12 - (length(data) - 1) * 4;
end

if nargin < 4 | isempty(relative)
	relative = true;
end
if ~relative
	for i = 1 : length(data)
		if size(data{i}, 2) > 1
			warning('Plot type has been changed to relative, because one of the inputs is a distribution function.');
			relative = true;
			break;
		end
	end
end

% Mid-point values of the bars
if length(xrange) > 2
	% If xrange has more than 2 elements,
	% they are the specified midpoints of histogram bars.
	x = xrange;
else
	x = linspace(xrange(1), xrange(2), nbin + 1);
	x = x(1 : end-1)/2 + x(2 : end)/2;
end



nbin = length(x);
	% This line makes senses only when the input XRANGE has more than 2 elements.

xi = x(1 : end-1)/2 + x(2 : end)/2;

y = zeros(length(data), nbin);


for i = 1 : length(data)
	if size(data{i}, 2) == 1
		y(i, :) = hist(data{i}, x);
		if relative
			y(i, :) = y(i, :) / length(data{i});
		end
	else
		n = interp1(data{i}(:, 2), data{i}(:, 1), xi);
		y(i, :) = [n(1), diff(n), 1 - n(end)];
	end
end


if nargout == 0
	% Plot on current figure.
	% The caller should prepare the window to plot on.

	h = bar(x', y', 1);

	if length(h) == 1
		set(h(i), 'FaceColor', 'none', 'EdgeColor', 'k');
	else
		clr = linspace(1, 0, length(h));
		for i = 1 : length(h)
			set(h(i), 'FaceColor', [clr(i), clr(i), clr(i)], 'EdgeColor', 'k');
		end
	end

	xlabel('Value');
	if relative
		ylabel('Relative frequency');
	else
		ylabel('Frequency');
	end

	xlim([x(1) - (x(2) - x(1))/2, x(end) + (x(end) - x(end-1))/2]);
	ymax = max(max(y)) * 1.05;
	if relative & ymax > 1
		ymax = 1;
	end
	ylim([0, ymax]);
end

 
