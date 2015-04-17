%transmit all float in cell into string
function r = num2str_cell(data)
    idx = cellfun(@isfloat,data);
    r(idx) = num2str(data);
end