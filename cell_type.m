% function data_type. to decide type of a matrix/vection.
% 0 for all float
% 1 for cell of float
% 2 for cell of char
% 3 for cell of float and char
% 4 for else
function flag = data_type(data)
    [m n] = size(data);
    if isa(data,'float')
        flag = 0;
        return;
    end
    if ~iscell(data)
        flag = 4;
        return;
    end
    sum_float = sum(sum(cellfun(@isfloat,data)));
    sum_char = sum(sum(cellfun(@ischar,data)));
    if sum_float == m*n
        flag = 1;
        return;
    elseif sum_char == m*n
        flag = 2;
        return;
    elseif sum_float + sum_char == m*n
        flag = 3;
        return;
    else
        flag = 4;
        return;
end