% transmit string column of cell into number. unique them and assign
% number. if not a column of cell, only return the first column. we return
% the numberized column r and the relation of string and number t
function [r t] = transmit_str2num(data)
    [m n] = size(data);
    uni = unique(data(:,1));
    len_uni = length(uni);
    r = zeros(m,1);
    for i = 1:len_uni
        idx = find(strcmp(data(:,1),uni{i,1}));
        r(idx,1) = i;
        t{i,1} = uni{i,1};
        t{i,2} = i;
        t{i,3} = length(idx);
        t{i,4} = t{i,3}/m;
    end
    
end