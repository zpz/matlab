function [Fx, Fy] = cdfsmooth(Fx, Fy, smoothlevel);
%  Smooth a empirical CDF curve and ensure monoticity.
%  FX should be a monotically increasing column vector.
%  FY should be a column vector of the same length.
%  Zepu Zhang
%  2004/12/05.

if nargin < 3 | isempty(smoothlevel)
	smoothlevel = 1;
end

if size(Fx, 2) > 1 | size(Fy, 2) > 1
	error('Both FX and FY must be column vectors.')
end

idx = find(Fy < 0 | Fy > 1);
if any(idx)
	Fx(idx) = [];
	Fy(idx) = [];
end

xdist = diff(Fx);
rightratio = xdist(1 : end-1) ./ (xdist(1 : end-1) + xdist(2 : end));

for ilevel = 1 : smoothlevel
	Fy(2 : end-1) = Fy(1 : end-2) .* (1 - rightratio) * 0.25 +...
					Fy(2 : end-1) * 0.75 +...
					Fy(3 : end) .* rightratio * 0.25;
end

idx = find(diff(Fy(1 : end-1)) < 1e-6);
while any(idx)
	Fx(idx + 1) = [];
	Fy(idx + 1) = [];
	idx = find(diff(Fy) < 1e-6);
end

