%�������ʱ������ϵĹ�ϵ
%����Ϊ���ϵ����ܵ�
%yyΪ����ʱ��-���ι��ϵĹ���̨��-�ϴι���̨��,���ϼ�i���µ�Ӳ����,���ϼ�i���µĻ�����
%yy1���ϼܳ�i���µĻ����й���ʱ��С��i�Ĺ��ϴ������ϼ�
%zzzΪ����ʱ��-������(Ӳ����)
%zzz1Ϊ����ʱ��-������(����̨��)
%zzz2Ϊ����ʱ��-������(Ӳ����)[����Ϊ��ĸ��ǰ����ʱ��С��i���µĸ���]
function [ret ret1]=ftime(raw_time,raw_a,f_count,num_dc,itm_f,itm_a)
col_fn_f=find_col('fail_count',itm_f);     %���ϵ���һ̨�������ֵĹ�����
col_ft_f=find_col('fail_time',itm_f);      %���ϻ����Ĺ���ʱ����
col_dc_a=find_col('dev_class_name',itm_a);      %����������
col_ut_f=find_col('used_time',itm_f);      %���ϻ��ѷ���ʱ��
col_ut_a=find_col('used_time',itm_a);      %���л����ѷ���ʱ��
t1=zeros(size(raw_time,1),max(cell2mat(raw_time(:,col_fn_f))));      %��������,�ٹ���
t2=zeros(size(raw_time,1),max(cell2mat(raw_time(:,col_fn_f))));      %��Ϊ����,��Ϊ���ϴ���
for i=1:size(t1,1)
    for j=1:min(size(t1,2),raw_time{i,col_fn_f})
        t1(i,j)=raw_time{i,col_ft_f}(j,1);  %���л����Ĺ���ʱ���,��ʾ��į�����ĵ�j�ι��ϵĹ���ʱ��
        t2(i,j)=raw_time{i,col_ut_f};             %���ϻ������ϼ�ʱ��
    end
end
f_count=min(f_count,size(t1,2));
t=t1(:,[1:f_count]);        %����Ҫ���������
t2=t2(:,[1:f_count]);

xx=1:max([max(t),1]);           %����ʱ��
yy=zeros(length(xx),f_count);   %��i���·������ϵĻ���̨��
yy1=zeros(length(xx),f_count);   %ǰi���·������ϵĻ���̨��
% waitbar(0.25,);
for i=1:length(xx)
    for j=1:f_count
        ind1=find(t(:,j)==xx(i));
        yy(i,j)=length(ind1);        %����ʱ��Ļ�����
    end
end
for i=1:length(xx)
    for j=1:f_count
         %���ϼܳ�i���µĻ����й���ʱ��С��i���µ�����
         ind1=find(t(:,j)<=xx(i));              %���ҹ���ʱ��С��i������
         ind_t2=ind1(find(t2(ind1,j)>=xx(i)));      %�ڴ˻����������ϼ�ʱ���ѳ���i���µ�
        yy1(i,j)=length(ind_t2);
    end
end


zz=zeros(max(xx),1);
zz1=zeros(max(xx),1);
% waitbar(0.5,h);
for i=1:length(zz)
%     waitbar(0.5+i*0.5/length(zz));
    ind=find(cell2mat(raw_a(:,col_ut_a))>i);          %�ϼ�ʱ�����i�Ļ�������
    if isempty(ind)
        continue;
    end
    ind=ind(find(cell2mat(raw_a(ind,col_ut_a))<96),1);    %8�����ϼܵĻ�������
    zz(i)=sum(num_hd(raw_a(ind,col_dc_a),num_dc));     %��Ӳ������Ϊ��ĸ
    zz1(i)=length(ind);                        %�Ի���̨����Ϊ��ĸ
end

if size(yy1,2)==1
    yy1=[yy1,yy1];
else
    yy1=[yy1,sum(yy1')'];
end
yy1=[xx',yy1];

if size(yy,2)==1
    yy=[yy,yy];
else
    yy=[yy,sum(yy')'];      %�ó������µĹ�����
end
yy=[xx',yy];        %����ʱ��-����̨��
yy=[yy,zz,zz1]; %��Ӳ����,����̨������
itm=[{'����ʱ��'},{'��1�ι���'},{'��2�ι���'},{'��3�ι���'},{'��4�ι���'},{'��5�ι���'}];
itm1=[{'�ϼ�'},{'���ϼ�Ӳ����'},{'���ϼܻ�����'}];
itm2=[{'����ʱ��'},{'��1�ι���'},{'��2�ι���'},{'��3�ι���'},{'��4�ι���'},{'��5�ι���'},{'�ϼ�'}];
num1=size(yy,2)-3;
item1=cat(2,itm(1,[1:num1]),itm1);
item2=itm2(1,[1:f_count+1,end]);
item3=itm2(1,[1:f_count+1,end]);
item4=itm2(1,[1:f_count+1,end]);
item5=itm2(1,[1:f_count+1,end]);

zzz=zeros(max(xx),1);       %������1
zzz(:,1)=xx;
zzz1=zeros(max(xx),1);      %������2
zzz1(:,1)=xx;
zzz2=zeros(max(xx),1);      %������3
zzz2(:,1)=xx;
for i=2:f_count+1
    zzz(:,i)=yy(:,i)./zz([1:max(xx)],1);
    zzz1(:,i)=yy(:,i)./zz1([1:max(xx)],1);
    zzz2(:,i)=yy1(:,i)./zz([1:max(xx)],1);
end
if size(zzz,2)==2
    zzz=[zzz,zzz(:,end)];
    zzz1=[zzz1,zzz1(:,end)];
    zzz2=[zzz2,zzz2(:,end)];
else
    zzz=[zzz,sum(zzz(:,[2:end])')'];
    zzz1=[zzz1,sum(zzz1(:,[2:end])')'];
    zzz2=[zzz2,sum(zzz2(:,[2:end])')'];
end

ret=[yy,yy1,zzz,zzz1,zzz2];
r1={cat(1,item1,num2cell(yy))};
r2={cat(1,item2,num2cell(yy1))};
r3={cat(1,item3,num2cell(zzz))};
r4={cat(1,item4,num2cell(zzz1))};
r5={cat(1,item5,num2cell(zzz2))};
ret1=[r1 r2 r3 r4 r5];
 
% yy=filter_infnan(yy);
% zzz=filter_infnan(zzz);
% zzz1=filter_infnan(zzz1);

% %���ʱ��
% t1=zeros(length(raw_time),10);
% for i=1:length(t1)
%     for j=1:min(raw_time{i,col_ntc}-1,10)
% %         t1(i,j)=round(cell2mat(raw_time{i,col_ntt}(j,2))/3)/10; %1λС��,��һ��������
%         t1(i,j)=cell2mat(raw_time{i,col_ntt}(j,2)); %1λС��,��һ��������
%     end
% end
% xx=0:max(max(t1));
% yyy=zeros(length(xx),10);
% for i=1:length(xx)
%     for j=1:10
%         yyy(i,j)=length(find(t1(:,j)==xx(i)));
%     end
% end
% yyy=[xx',yyy];