%把合并的单再拆开
function raw_f=raw_split(raw)
    count=1;
    col_num=10;
    raw_f=cell(1,1);
    len=size(raw,1);
    for i=1:len
        len1=raw{i,col_num};
        for j=1:len1
            raw_f(count,[1:8])=[raw(i,[1:8])];
            raw_f{count,9}=raw{i,9}{j,1};
            raw_f{count,10}=raw{i,11}{j,1};
            raw_f{count,11}=raw{i,11}{j,2};
            raw_f{count,12}=raw{i,12};
            count=count+1;
        end
    end
end

