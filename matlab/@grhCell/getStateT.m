function s = getStateT(obj, t)

% get state for cell at time t

t = t - obj.firstSeen + 1;
try
s = obj.states{t};
catch exGetStateT
    exGetStateT
end

