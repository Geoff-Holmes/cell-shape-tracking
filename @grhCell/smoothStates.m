function obj = smoothStates(obj, model)

% obj = smoothStates(obj)
% 
% A grhCell object containes it's own filtered states, state covariances
% and C observation matrices hence it can perform RTS smoothing on itself
% given the model matrices

% initialise
T = length(obj.states);
Pfilt = obj.covariance;
Xfilt = obj.states;
Psmth{T} = Pfilt{T};
Xsmth{T} = Xfilt{T};

% RTS smoother
for t = T-1:-1:1
    
    Ppred = model.A * Pfilt{t} * model.A' + model.W;
    S = Pfilt{t} * model.A' * pinv(full(Ppred));
    smthState = Xfilt{t} + S * (Xsmth{t+1} - model.A * Xfilt{t});
    Psmth{t} = Pfilt{t} + S * (Psmth{t+1} - Ppred) * S';
    obj.snake(t).ctrlPts = smthState(1:obj.Bspline.L);
    Xsmth{t} = smthState;
    
end

% update cell object
obj.covariance = Psmth;
obj.states     = Xsmth;
obj.smoothed   = 1;
    
