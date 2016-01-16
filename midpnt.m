function s = midpnt(g, lb, ub, tol, varargin);
% MIDPNT(G, LB, UB, ...)
%
% The Extended Midpoint Rule for integration where
% the integral has sigularity at the limits of the integration interval:
%   int_{lb}^{ub} g(x) dx
%
% G is a function of x.
% Additional parameters in addition to X are passed in after UB.
%
% LB and UB are integration limits.
%
% Zepu Zhang
%   2004/11/26.
%   2004/12/09.


if nargin < 4 | isempty(tol)
	tol = 1/500;
end

n = 100;
h = (ub - lb) / n;
x = linspace(lb, ub, n + 1);
x = (x(1 : end-1) + x(2 : end)) / 2;
x = x';

if isempty(varargin)
	y = feval(g, x);
else
	y = feval(g, x, varargin{:});
end
if any(isnan(y)) | ~isreal(y)
	warning('There exists NAN or imaginary figures in Y.');
end
s = h * sum(y);

maxvaluepoints = 100000;
log3 = 1.0986;    % log(3)
nloopmax = ceil(log(maxvaluepoints / length(x)) / log3);


for iloop = 1 : nloopmax 
	h = h/3;
	x1 = x - h;
	x2 = x + h;

	xnew = [x1; x2];
	if isempty(varargin)
		ynew = feval(g, xnew);
	else
		ynew = feval(g, xnew, varargin{:});
	end
	if any(isnan(ynew)) | ~isreal(ynew)
		warning('There exists NAN or imaginary figures in YNEW.');
	end

	sold = s;
	s = sold/3 + h * sum(ynew);

	x = [x1; x; x2];
	clear x1, x2;

	if iloop > 4 & abs(s - sold) < abs(sold) * tol
		break;
	end
end

if iloop == nloopmax
	v = (s - sold) / sold * 100;
	if v > 1
		warning(sprintf('maximum number of iterations reached. %g  %6.2f%%',...
			s, v));
	end
end


