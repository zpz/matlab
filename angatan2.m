function ang = angatan2(ang);
% Make angle into the range of the output of function ATAN2, 
% i.e., [-pi, pi].

idx = find(ang > pi);
ang(idx) = ang(idx) - 2 * pi;

idx = find(ang < -pi);
ang(idx) = ang(idx) + 2 * pi;

