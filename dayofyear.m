function day = dayofyear(datesrnum);
% DATESRNUM is returned by DATENUM. 

dvec = datevec(datesrnum);
day = datesrnum - datenum(dvec(:,1), 1, 1, 0, 0, 0);

