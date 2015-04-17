% function num_class. count number of each class
function r = num_class(uni,data)
    len = length(uni);
    r = zeros(len,1);
    flag = data_type(data); 
    if flag == 1        %turn cell to float
        data = cell2mat(data);
        flag = 0;
    elseif flag == 3    %turn numer to string
        [m n] = cellfun(@isfloat,data);
        data(m,n) = num2str(data(m,n));
        flag = 2;
    end
    
    if flag == 0
        for i = 1:len
            r(i,1) = length(find(uni(i) == data));
        end
    elseif flag == 2
        for i = 1:len
            r(i,1) = length(find(strcmp(uni{i},data)));
        end
    else
        error('Wrong type');
    end
end