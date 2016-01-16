function [Fy, Fx] = ecdfrobust(varargin);
% Fix various problems in empirical cdf.
%
% Last modified: 2004/09/12.


if nargin == 1
	[Fy, Fx] = ecdf(varargin{1});
else
	Fy = varargin{1};
	Fx = varargin{2};
end

% enforce correct value range.
idx = find(Fy < 0);
if any(idx)
	warning('There are negative CDF values. Replaced by 0.');
	fprintf(1, 'Negative (x, F(x)) CDF values are\n');
	fprintf(1, '%g  %g\n', [reshape(Fx(idx), 1, length(idx)); reshape(Fy(idx), 1, length(idx))]);
	fprintf(1, '\n');
	Fy(idx) = 0;
end
idx = find(Fy > 1);
if any(idx)
	warning('There are CDF values greater than 1. Replaced by 1.');
	Fy(idx) = 1;
end


% enforce monotonousness.
if ~issorted(Fx)
	Fx = sort(Fx);
end
if ~issorted(Fy)
	Fy = sort(Fy);
end


% enforce unique X values.
smallgap = (Fx(end) - Fx(1)) * eps;
while 1 
	idxdupe = find(Fx(2 : end) < Fx(1 : end-1) + smallgap) + 1;
	if isempty(idxdupe)
		break;
	else
		Fx(idxdupe) = [];
		Fy(idxdupe) = [];
	end
end

% enforce unique Y values.
smallgap = 1e-8;
while 1 
	idxdupe = find(Fy(2 : end) < Fy(1 : end-1) + smallgap) + 1;
	if isempty(idxdupe)
		break;
	else
		Fx(idxdupe) = [];
		Fy(idxdupe) = [];
	end
end



% enforce correct value range.
if Fy(1) ~= 0 | Fy(end) ~= 1
	warning('The estimated CDF function value range is not [0, 1]');
end

