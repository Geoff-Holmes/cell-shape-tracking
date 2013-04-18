function [ctrlPts, snake] =  dataFit(obj, data, plt)

% ctrlPts          =  dataFit(obj, data)
% ctrlPts]         =  dataFit(obj, data, plt)
% [ctrlPts, snake] =  dataFit(obj, data)
% [ctrlPts, snake] =  dataFit(obj, data, plt)

% Determine control points to fit spline function to inputted data
% data can be complex representation of x-y data

szData = size(data);
if szData(2) > szData(1), data = conj(data');end
szData = size(data);
if szData(2) > 1, data = data * [1; 1i]; end
nData = length(data);

% divide up path parameter
sData = linspace(0, obj.L, nData+1);
sData = sData(1:end-1);

% initialise least squares design matrixs
DsnMat = zeros(nData, obj.L);

% populate design matrix
brkPts = 1:obj.L;
for i = 1:nData
    % find which span is needed
    sig = find(sData(i) < brkPts, 1);
    DsnMat(i,:) ...
    = (sData(i) - brkPts(sig)+1).^(0:obj.d-1) * obj.BS * obj.G(:,:,sig);
end

% get control points via least squares
ctrlPts = (DsnMat' * DsnMat) \ DsnMat' * data;

% optional plotting
if nargin > 2
    figure(); hold on;
    plot(data, '.')
    plot(obj.curve(ctrlPts))
    plot(ctrlPts, 'r+')
end

% return ctrlPts snake if requested
if nargout > 1
    snake = grhSnake(ctrlPts, obj);
end
