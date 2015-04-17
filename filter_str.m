%总单/故障单过滤函数,用于过滤某一字段的数据
%输入为总单(cell),以及要过滤的列数(double)
%及用于匹配的关键字(char/cell),关键字可以为多个,m*1的cell
function [ind1 ret]=filter_str(raw,col,str)
    [m n]=size(str);
    ret={};
    
    if iscell(str) && n~=1
        disp('多列数据,只处理第一列');
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