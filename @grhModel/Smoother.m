function [Xsmth, Psmth] = Smoother(obj, Xfilt, Pfilt)

% [Xsmth, Psmth] = Smoother(obj, Xfilt, Pfilt)
% 
% apply RTS smoothing step to prefiltered process

% initialise
T = length(Xfilt);
Psmth{T} = Pfilt{T};
Xsmth{T} = Xfilt{T};

% RTS smoother
for t = T-1:-1:1
    
    % get one step ahead predicted covariance
    Ppred = obj.A * Pfilt{t} * obj.A' + obj.W;
    % get smoothing gain
    S = Pfilt{t} * obj.A' / Ppred;
    % smooth state
    Xsmth{t} = Xfilt{t} + S * (Xsmth{t+1} - obj.A * Xfilt{t});
    % smooth covariance
    Psmth{t} = Pfilt{t} + S * (Psmth{t+1} - Ppred) * S';
        
end
    
