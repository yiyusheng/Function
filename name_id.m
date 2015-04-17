%给数据进行编号,首先把所有的数据取出,进行unique操作,为不同的项给一个数字,给出数据的编号,以及对应的表
%输入:一列(cellstring)
%输出:这一列对应的编号(double),编号对应表,编号+列,
function [ret r2 r1 ]=name_id(m)
    len_m=size(m,1);
    uni_m=unique(m);
    id=(1:size(uni_m,1))';
    r2=cat(2,uni_m,num2cell(id));
    ds_m=cell2dataset(cat(1,{'element'},m));
    ds_r2=cell2dataset(cat(1,[{'element'},{'id'}],r2));
    r1=join(ds_m,ds_r2,'element');
    r1=dataset2cell(r1);
    r1=r1([2:end],:);
    ret=cell2mat(r1(:,2));
end