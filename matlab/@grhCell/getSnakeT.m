function s = getSnakeT(obj, t)

% get snake for cell at time t

t = t - obj.firstSeen + 1;
try
s = obj.snake(t);
catch ex3
    exGetSnakeT
end

