function idx = findlast(X)

idx = find(X);
if any(idx)
	idx = idx(end);
end


