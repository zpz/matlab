function setfigpaper(hfig, width, height, papertype);
%  Arange the figure on the paper onto which it is printed or saved.
%  This function is usually used to figure windows with only one axes.

if nargin < 1 | isempty(hfig)
	hfig = gcf;
end
if nargin < 2
	width = [];
end
if nargin < 3
	height = [];
end
if nargin < 4 | isempty(papertype)
	papertype = 'usletter';
end
if nargin < 5 | isempty(ignorefont)
	ignorefont = false;
end

switch papertype
case 'usletter'
	papersize = [8.5, 11]; % inches
case 'A4'
	papersize = [210, 297]; % mm
	papersize = papersize / 25.4;  % inches
otherwise
	error('Unknown paper type');
end
	% Width and height arguments should be in the same units
	% as that used for the definition of papersize.

% If either width or height is missing,
% aspect ratio of the figure window is honored.
if isempty(width) | isempty(height)
	pos = get(hfig,'Position');
	% pos is figure window dimension on the monitor, in pixels,
	% [left, bot, wid, hgt]

	if isempty(width) & ~isempty(height)
		width = height * pos(3)/pos(4);
	elseif isempty(height) & ~isempty(width)
		height = width * pos(4)/pos(3);
	else
		set(hfig, 'PaperOrientation', 'portrait');
		width = 0.6 * papersize(1);
		height = width * pos(4)/pos(3);
	end
end

if width > papersize(1) * 0.95
	set(hfig, 'PaperOrientation', 'landscape');
else
	set(hfig, 'PaperOrientation', 'portrait');
end

left = (papersize(1) - width) / 2;
bottom = (papersize(2) - height) / 2;

% Make sure enough border to show labels.

h = get(hfig, 'Children');
for ih = 1 : length(h)
	if ~strcmp(get(h(ih), 'Type'), 'axes')
		continue;
	end

	if strcmp(get(h(ih), 'Tag'), 'legend')
		continue;
	end

	set(h(ih), 'Units', 'normalized');
	oldpos = get(h(ih), 'Position');

	oldfunit = get(h(ih), 'FontUnits');
	set(h(ih), 'FontUnits', 'inch');
	fsize = get(h(ih), 'FontSize');
	set(h(ih), 'FontUnits', oldfunit);

	exlbor = 0;
	exbbor = 0;
	extbor = 0;
	xtick = get(h(ih), 'XTickLabel');
	ytick = get(h(ih), 'YTickLabel');
	xlab = get(get(h(ih), 'XLabel'), 'String');
	ylab = get(get(h(ih), 'YLabel'), 'String');
	tit = get(get(h(ih), 'Title'), 'String');
	if any(xtick)
		exbbor = exbbor + 0.1 + fsize * 1.1;
	end
	if any(xlab)
		exbbor = exbbor + 0.1 + fsize * 1.1;
	end
	if any(tit)
		extbor = extbor + 0.1 + fsize * 1.1;
	end
	if any(ytick)
		exlbor = exlbor + 0.1 + size(ytick, 2) * fsize * 1.1;
	end
	if any(ylab)
		exlbor = exlbor + 0.1 + fsize * 1.1;
	end

	pos = oldpos;
	if exlbor > pos(1) * width
		pos(1) = exlbor / width;
		pos(3) = oldpos(3) - (pos(1) - oldpos(1));
	end
	if exbbor > pos(2) * height
		pos(2) = exbbor / height;
		pos(4) = oldpos(4) - (pos(2) - oldpos(2));
	end
	if extbor > (1 - pos(2) - pos(4)) * height
		pos(4) = 1 - pos(2) - extbor / height;
	end

	set(h(ih), 'Position', pos);
end

set(hfig, 'PaperPosition',[left, bottom, width, height]);

