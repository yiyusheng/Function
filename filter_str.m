%�ܵ�/���ϵ����˺���,���ڹ���ĳһ�ֶε�����
%����Ϊ�ܵ�(cell),�Լ�Ҫ���˵�����(double)
%������ƥ��Ĺؼ���(char/cell),�ؼ��ֿ���Ϊ���,m*1��cell
function [ind1 ret]=filter_str(raw,col,str)
    [m n]=size(str);
    ret={};
    
    if iscell(str) && n~=1
        disp('��������,ֻ�����һ��');
    end
    ind1=[];
    if m==1
        ind=find(strcmp(raw(:,col),str));
        ind1=ind;
        ret=raw(ind,:);
    else
        for i=1:m
            ind=find(strcmp(raw(:,col),str{i}));
            ret=cat(1,ret,raw(ind,:));
            ind1=[ind1;ind];
        end
    end
end