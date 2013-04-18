function p = plot(obj, i)

% plot the cell outline at time i using basis Bspline
if nargin > 1
    p = plot(obj.snake(i));
else
    hold on
    for i = 1:length(obj.snake)
        p(i) = plot(obj.snake(i));
    end
end