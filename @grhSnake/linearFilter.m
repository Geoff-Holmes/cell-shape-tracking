function [ctrlPtsFiltered, snakeFiltered] = linearFilter(obj, d)

% perform linear filtering on snakes control points
% if d = 2:
% each ctrlPt is averaged with neighbour on each side with weights [1 2 1]/4 
% if d = 3:
% averaged with weights [1 2 3 2 1]/9 etc

% filtering matrix
F = sparse(toeplitz([d:-1:1 zeros(1,obj.Bspline.L-2*d+1) 1:d-1])/d^2);

ctrlPtsFiltered = F * obj.ctrlPts;

if nargout == 2
    snakeFiltered = grhSnake(ctrlPtsFiltered, obj.Bspline);
end
