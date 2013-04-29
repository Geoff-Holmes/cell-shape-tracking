function showBasis(obj)

figure;
for i = 1:obj.L
    ctrlPts = 1:obj.L == i;
    F(:,i) = obj.curve(ctrlPts);
end
F(:,end+1) = obj.curve(ones(1,obj.L));
plot(F)