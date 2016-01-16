function idx = findfirst(X)

idx = find(X);
if any(idx)
	idx = idx(1);
end


