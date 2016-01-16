function s = trapzd(g, lb, ub, varargin);
% TRAPZD(G, LB, UB, ...)
%
% The Extended Trapezoidal Rule for integration where
% the integral is regular in the entire integration interval, i.e., no sigularities.
%
% G is an inline function of x.
% Additional parameters in addition to X are passed in after UB.
%
% LB and UB are integration limits.
%
% Zepu Zhang
% Last modified:  2004/09/02.


n = 100;
h = (ub - lb) / n;
x = linspace(lb, ub, n + 1);

if isempty(varargin)
	y = feval(g, x);
else
	y = feval(g, x, varargin{:});
end
if any(isnan(y)) | ~isreal(y)
	warning('There exist NAN or imaginary figures in Y.');
end
s = h * (y(1) + sum(y(2 : end-1)) + y(end));
x(end) = [];

maxvaluepoints = 100000;
log3 = 1.0986;    % log(3)
nloopmax = ceil(log(maxvaluepoints / length(x)) / log3);

for iloop = 1 : nloopmax 
	h = h/2;
	xnew = x + h;
	if isempty(varargin)
		ynew = feval(g, xnew);
	else
		ynew = feval(g, xnew, varargin{:});
	end

	if any(isnan(y)) | ~isreal(ynew)
		warning('There exist NAN or imaginary figures in YNEW.');
	end

	sold = s;
	s = sold/2 + h * sum(ynew);
	s = 4/3*s - sold/3;

	%fprintf(1, '%g\n', s);

	x = [x, xnew];

	if iloop > 4 & abs(s - sold) < abs(sold / 300) 
		break;
	end
end

if iloop == nloopmax
	warning(sprintf('maximum number of iterations reached.  %g,  %6.2f%%',...
		s, (s - sold)/sold * 100));
end

