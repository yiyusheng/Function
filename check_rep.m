%�����ͬԪ��
%����,һ��cell,���,���ֶ�ε�Ԫ��,�Լ����ֵ�����
function [ret ret1]=check_rep(m)
    len_m=length(m);
    [m1 ia]=sort(m);
    ind1=[];    %�ظ�Ԫ�ص�һ��������������
    tmp=m1{1};
    for i=2:len_m
        if ~strcmp(tmp,m1{i})
            tmp=m1{i};
            continue;
        else
            ind1=[ind1;i];
        end
    end
    uni_r=unique(m1(ind1,:));   %����Ԫ��
    len_u=size(uni_r,1);
    collect=cell(len_u,1);
    ret1=[];    %�ռ�������ͬԪ�ص�����
    for i=1:len_u
        ind2=find(strcmp(m,uni_r{i}));     %m1�е���ͬ������
        collect{i}=ind2;
        ret1=[ret1;ind2];
    end
    ret=cat(2,uni_r,collect);
end