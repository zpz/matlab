function y = capitalize(x);
% Capitalize first letter of each word.
% X is a character string.

y = lower(x);

directionwords = {'ne', 'nw', 'se', 'sw', 'nne', 'nnw', 'sse', 'ssw'};
for i = 1 : length(directionwords)
	w = directionwords{i};
	idx = strfind(y, [' ', w, ' ']);
	if any(idx)
		for j = idx
			y(j : j + length(w)) = upper(y(j : j + length(w)));
		end
	end
end

idx = isletter(y);
if any(idx)
	idx = (diff([0, idx]) == 1);
	y(idx) = upper(y(idx));
end

