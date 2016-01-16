function groupboxplot(X, Data, Colors);
%  This plot compares the distribution of a variable
%  that changes with the level of another variable.
%  For example, distribution of variable A varies as the
%  level of B varies. We want to compare the distributions of A
%  at two locations.
%  We can make this plot to show 10 percentiles of A at each
%  of 5 levels of B.
%  In each B level, the 10 percentiles of A at location 1
%  are ploted side by side with those at location 2.
%
%  Each element matrix of cell array DATA represents a series.
%  If the matrix is M by N, then
%  N is number of locations in the series,
%  M is number of values, usually percentiles, at each location.
%  The plot places values at one location from all series side by side.
%  Number of locations or percentiles can be different for different series.
%
%  COLORS specifies in each row the color for each series.
%  If COLORS has less rows than the number of series,
%  colors in COLORS are usely by cycling.
%  COLORS can specify colors by either single-character color names, or 
%  RGB triples.
%  When missing, default colors are cycled for series.

if ( ~iscell(Data) )
	Data = {Data};
end

if (isempty(X))
	X = 1 : size(Data{1}, 2);
end

HAxes = gca;
if (nargin == 2 | isempty(Colors))
	Colors = get(HAxes, 'ColorOrder');
end


SeriesCount = length(Data);

HFig = gcf;
HAxes = gca;

while (size(Colors, 1) < SeriesCount)
	Colors = [Colors; Colors(1 : min(size(Colors, 1), SeriesCount - size(Colors, 1)), :)];
end

LocationCount = 0;

GroupWidth = 0.75 * (X(2) - X(1));
SeriesWidth = GroupWidth / SeriesCount;
BarFraction = 0.5;  % fraction data bars take in the entire GroupWidth
BarWidth = SeriesWidth * BarFraction;

ybound = [realmax, -realmax];
	% min and max of y.

for i = 1 : SeriesCount
	ybound(1) = min(ybound(1), min(min(Data{i})));
	ybound(2) = max(ybound(2), max(max(Data{i})));


	for j = 1 : size(Data{i}, 2)
		XLoc = X(j) - GroupWidth/2 + (i - 1 + 0.5) * SeriesWidth;

		plot([XLoc, XLoc], [min(Data{i}(:,j)), max(Data{i}(:,j))],...
			'-', 'Color', Colors(i,:));
		hold on;
		for (k = 1 : size(Data{i}, 1))
			plot([XLoc - BarWidth/2, XLoc + BarWidth/2], [Data{i}(k,j), Data{i}(k,j)], ...
				'-', 'Color', Colors(i,:));
		end
	end

	LocationCount = max(LocationCount, size(Data{i}, 2));
end

xlim([X(1) - (X(2) - X(1))/2, X(end) + (X(end) - X(end-1))/2]);
ylim([ybound(1) - (ybound(2) - ybound(1))/10, ybound(2) + (ybound(2) - ybound(1))/10]);

set(HAxes, 'XTick', X);
%set(HAxes,'XTick',[1 : LocationCount]);

hold off;

