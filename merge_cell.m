%%%IMPORTANT MERGE!!!
%merge based on col_id, sort by col_sort and merge column col_m1 and col_m2
%col_id: unique column in result
%col_sort: sort based on this column before merge
%col_m1: length of cell in these column are the same
%col_m2: length of cell in these column are not the same
%%%
function r=merge_cell(data,col_id,col_sort,col_m1,col_m2)
    data1 = sortrows(data,[col_id,col_sort]);       %sort first  
    if data_type(data(:,col_id)) == 1
        uni_id = unique(cell2mat(data1(:,col_id)));
    else
        uni_id = unique(data1(:,col_id));
    end
    len_id = length(uni_id);
    r = cell(length(len_id),size(data1,2)+1);   %add a count column
    %r(:,end) = num2cell(ones(len_d1),1);
    %index and value
    ind_p = 1;
    p = data1{ind_p,col_id};
    %result and count
    count = 1;
    r(count,1:end-1) = data1(ind_p,:);    %copy all
    h = waitbar(0,'merge');
    len = length(data1);
    for i =2:len
        waitbar(i/len);
        %another id index and value
        ind_q = i;
        q = data1{ind_q,col_id};
        if (ischar(q) && strcmp(p,q)) || (isfloat(q) && p == q)
            continue;
        else
            % same length column in m*n double/char array
            % nosame length clumn in m*n cells
            r{count,end} = ind_q-ind_p;
            ind_need = ind_p:ind_q-1;
            for j = 1:length(col_m1)
                tmp = data1(ind_need,col_m1(j));
                r{count,col_m1(j)} = cell2mat(tmp);
            end
            for j = 1:length(col_m2)
                tmp = data1(ind_need,col_m2(j));
                r{count,col_m2(j)} = tmp;
            end
            
            count = count+1;
            ind_p = ind_q;
            p = data1{ind_p,col_id};
            r(count,1:end-1) = data1(ind_p,:);
        end
    end
    %%for the last one
    r{count,end} = ind_q-ind_p+1;
    ind_need = ind_p:ind_q;
    for j = 1:length(col_m1)
        tmp = data1(ind_need,col_m1(j));
        r{count,col_m1(j)} = cell2mat(tmp);
    end
    for j = 1:length(col_m2)
        tmp = data1(ind_need,col_m2(j));
        r{count,col_m2(j)} = tmp;
    end
    close(h);
end