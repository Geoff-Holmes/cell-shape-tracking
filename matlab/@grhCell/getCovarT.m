function s = getCovarT(obj, t)

% get snake for cell at time t

t = t - obj.firstSeen + 1;
s = obj.covariance{t};


