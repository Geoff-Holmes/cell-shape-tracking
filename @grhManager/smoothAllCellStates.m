function obj = smoothAllCellStates(obj)

for i = 1:length(obj.cells)
    
    obj.cells(i).smoothStates(obj.Model);
    
end