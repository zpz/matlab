function [a, b] = scurve(a, halfx);
% 1 - (1 + a) / (1 + a * exp(b * x))
% A controls the curvature;
% B controls how fast the curves reaches 1.
% A in [0.005, 0.05] gives a pretty nice shape.
%
% Let (1 + a) / (1 + a * exp(b * halfx)) = 1/2
% ==>
%   b = log(1/a + 2) / halfx

if isempty(a)
	a = 0.05;
end
b = log(1/a + 2) / halfx;



