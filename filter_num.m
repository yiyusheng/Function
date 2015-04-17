%总单/故障单过滤函数,用于过滤某一字段的数据,类型为double.(a,b]
%输入为总单(cell),以及要过滤的列数(double)
%及用于匹配的关键字(double),关键字可以为多个,m*1的cell
%选取线段上一个范围,大于num1,小于等于num2
function ret=filter_num(raw,col,num1,num2)
    if num1>num2
      temp=num1;
      num1=num2;
      num2=temp;
    end
    data=raw(:,col);
    if iscell(data)
        data=cell2mat(data);
    end
    ind=find(data>num1);
    ind=ind(find(data(ind,1)<=num2));
    ret=raw(ind,:);
end