%检查相同元素
%输入,一列cell,输出,出现多次的元素,以及出现的索引
function [ret ret1]=check_rep(m)
    len_m=length(m);
    [m1 ia]=sort(m);
    ind1=[];    %重复元素第一个索引的索引集
    tmp=m1{1};
    for i=2:len_m
        if ~strcmp(tmp,m1{i})
            tmp=m1{i};
            continue;
        else
            ind1=[ind1;i];
        end
    end
    uni_r=unique(m1(ind1,:));   %独立元素
    len_u=size(uni_r,1);
    collect=cell(len_u,1);
    ret1=[];    %收集所有相同元素的索引
    for i=1:len_u
        ind2=find(strcmp(m,uni_r{i}));     %m1中的相同项索引
        collect{i}=ind2;
        ret1=[ret1;ind2];
    end
    ret=cat(2,uni_r,collect);
end