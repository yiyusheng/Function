%把raw_t展开成raw_f
%输入:要展开的cell,要展开的列数
%expandf(raw_t,[1,4,8,9,10]);
function raw_f=expandf(raw_t,col)
    [m n]=size(raw_t);
    len_c=size(col,2);
    count=0;        %计算最后有多少行
    for i=1:m
        count=count+size(raw_t{i,col(1)},1);
    end

    col_=zeros(1,n);
    col_(1,col)=1;
    col_one=find(col_==0);      %col_one为不要展开的列

    raw_f=cell(count,n);
    c=1;
    for i=1:m
        len=size(raw_t{i,col(1)},1);
        if len==1
            raw_f(c,:)=raw_t(i,:);
            c=c+1;
            continue;
        end
        
        line=raw_t(i,col_one);
        for j=1:len
            raw_f(c+j-1,col_one)=line;
            for k=1:len_c
                if isa(raw_t{i,col(k)},'double')
                    raw_f([c:c+len-1],col(k))=num2cell(raw_t{i,col(k)});
                else
                raw_f([c:c+len-1],col(k))=raw_t{i,col(k)};
                end
            end
        end
        c=c+len;
    end
end