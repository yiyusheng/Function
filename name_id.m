%�����ݽ��б��,���Ȱ����е�����ȡ��,����unique����,Ϊ��ͬ�����һ������,�������ݵı��,�Լ���Ӧ�ı�
%����:һ��(cellstring)
%���:��һ�ж�Ӧ�ı��(double),��Ŷ�Ӧ��,���+��,
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