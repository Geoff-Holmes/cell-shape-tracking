function c = getObsRefsT(obj, t)

% get obsRef of cell at time t

t = t - obj.firstSeen + 1;
try
c = obj.obsRefs(t);
catch exGetObsRefsT
    exGetObsRefsT
end
    

