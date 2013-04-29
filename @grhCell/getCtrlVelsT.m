function s = getCtrlVelsT(obj, t)

% get control point velocities for cell at time t

t = t - obj.firstSeen + 1;
try
s = obj.ctrlVelocities{t};
catch ex3
    exGetCtrlVelsT
end

