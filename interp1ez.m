function yi = interp1ez(x, y, xi, slope);
%INTERP1EZ 1-D piece-wise linear interpolation, easy version.
%   YI = INTERP1EZ(X,Y,XI) interpolates to find YI, the values of
%   the underlying function Y at the points in the vector XI.
%   The vector X specifies the points at which the data Y is
%   given. 
%
%   X and Y are vectors of the same size.
%   X, Y should both be either row vectors or column vectors.
%   XI is a vector or a scaler.
%
%   X must be monotonously increasing.
%
%   This function is faster than Matlab's INTERP1 and INTERP1Q
%   because it minimizes input checks.
%
%   Zepu Zhang
%     2004/11/26.

if nargin < 4
	slope = diff(y) ./ diff(x);
end

[ignore, k] = histc(xi, x);
k(xi < x(1) | isnan(xi)) = 1;
k(xi >= x(end) | k >= length(x)) = length(x) - 1;
      
yi = y(k) + (xi - x(k)) .* slope(k);

