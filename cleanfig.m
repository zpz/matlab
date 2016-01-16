function cleanfig(fn);
% Comment out the annoying Matlab label in figure files
% in the current directory..
%
% Common usage:
%   cleanfig(ls('../plots/*.eps'));


if nargin < 1 | isempty(fn)
	fn = strread(ls('*.eps'), '%s');
else
	if ~iscell(fn)
		fn = strread(fn, '%s');
	end
end


for i = 1 : length(fn)
	fname = fn{i};
	fnametmp = tempname;

	fprintf(1, 'Processing image file %s\n', fname);

	fin = fopen(fname, 'r');
	fout = fopen(fnametmp, 'w');
	while 1
		tline = fgetl(fin);
		if ~ischar(tline), break, end

		if strncmp(tline, '(Student Version of MATLAB) show', 32)
			tline = ['%', tline];
		end

		fprintf(fout, '%s\n', tline);
	end

	fclose(fout);
	fclose(fin);

	movefile(fnametmp, fname);
end

