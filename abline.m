function h = abline(a, b, varargin);
% Draw line Y = aX + b on current plot,
% honoring the existing X and Y ranges.

xl = xlim;
yl = ylim;

if a >= realmax
	x = [b, b];
	y = yl;
else
	x = xl;
	y = a * x + b;
end

if nargin < 3
	plot(x, y);
else
	plot(x, y, varargin{:});
end

