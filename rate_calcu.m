function rate=rate_calcu(data)
    %计算不同类型的比例
    %输入: [n 1]的列向量
    %输出: 列向量中不同的类型及比例,[m 2]矩阵
    %将cell类型,且每一个cell中存的都是1*1的double转为str
    if isa(data,'cell') && isa(data{1,1},'double') && isa(cell2mat(data),'double')
        data=cellstr(num2str(cell2mat(data)));
    end
    [m n]=size(data);
    uni_var=unique(data);
    uni_len=length(uni_var);
    rate=zeros(uni_len,2);
    if iscell(data)
        for i=1:uni_len
            rate(i,1)=length(find(strcmp(data(:),uni_var{i})));
            rate(i,2)=rate(i,1)/m;
        end
        rate=cat(2,uni_var,num2cell(rate));
        rate=flipud(sortrows(rate,2));
    elseif isnumeric(data)
        for i=1:uni_len
            rate(i,1)=length(find(data(:)==uni_var(i)));
            rate(i,2)=rate(i,1)/m;
        end   
        rate=cat(2,num2cell(uni_var),num2cell(rate));
        rate=sortrows(rate,1);
    end
    %加入累积比例
    accu=zeros(size(rate,1),1);
    r3=cell2mat(rate(:,3));
    accu(1)=r3(1,1);
    for i=2:size(rate,1)
        accu(i)=accu(i-1)+r3(i);
    end
    rate=cat(2,rate,num2cell(accu));
end
