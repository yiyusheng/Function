%�ܵ�/���ϵ����˺���,���ڹ���ĳһ�ֶε�����,����Ϊdouble.(a,b]
%����Ϊ�ܵ�(cell),�Լ�Ҫ���˵�����(double)
%������ƥ��Ĺؼ���(double),�ؼ��ֿ���Ϊ���,m*1��cell
%ѡȡ�߶���һ����Χ,����num1,С�ڵ���num2
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