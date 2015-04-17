function rate=rate_calcu(data)
    %计算不同类型的比例
    %输入: [n 1]的列向量
    %输出: 列向量中不同的类型及比例,[m 2]矩阵
    %对数值值的vector或cell都以数值存,对混合型和cell都用str存
%     if isa(data,'cell') && isa(data{1,1},'double') && isa(cell2mat(data),'double')
%         data=cellstr(num2str(cell2mat(data)));
%     end
    %% cell convert
    ct = cell_type(data);
    if ct == 3
        data = cell_convert(data);
    elseif ct == 1
        data = cell2mat(data);
    end
    %% rate calculate
    [m n]=size(data);
    uni_var=unique(data);
    uni_len=length(uni_var);
    rate=zeros(uni_len,2);
    if ct == 2 || ct ==3
        for i=1:uni_len
            rate(i,1)=length(find(strcmp(data(:),uni_var{i})));
            rate(i,2)=rate(i,1)/m;
        end
        rate=cat(2,uni_var,num2cell(rate));
        rate=sortrows(rate,-2);
    elseif ct == 0 || ct == 1
        for i=1:uni_len
            rate(i,1)=length(find(data(:)==uni_var(i)));
            rate(i,2)=rate(i,1)/m;
        end   
        rate=cat(2,num2cell(uni_var),num2cell(rate));
        rate=sortrows(rate,-2);
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
