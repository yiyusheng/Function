%�������ʱ������ϵĹ�ϵ
%����Ϊ���ϵ����ܵ�
% y_mcount_startΪ���ϼ�ʱ��Ϊ��׼�������ʱ��õ���ÿ�����ڵĹ��ϴ���
% y_mcount_lastΪ���ϴι���ʱ��Ϊ��׼�������ʱ��õ���ÿ�����ڵĹ��ϴ���
% x_ftimeΪ����ʱ��
% y_hdcountΪ���ϼ�ʱ��Ϊ��׼��������ϼ�i���µ�Ӳ����
% y_mcountΪ���ϼ�ʱ��Ϊ��׼��������ϼ�i���µĻ�����
%f_countΪͳ�ƵĹ��ϴ���,���n���·�����m�ι��ϵĹ�����,��f_count=-1��ͳ�����й���.��ͳ�ƴ���
function [ret_need ret_all]=ftime_1(raw_t,raw_a,f_count,num_dc,itm_f,itm_a)
col_fc_f=find_col('fail_count',itm_f);     %���ϵ���һ̨�������ֵĹ�����
col_ft_f=find_col('fail_time',itm_f);      %���ϻ����Ĺ���ʱ����
col_dc_a=find_col('dev_class_name',itm_a);      %����������,���ڼ���Ӳ����
col_ut_f=find_col('used_time',itm_f);      %���ϻ��ѷ���ʱ��
col_ut_a=find_col('used_time',itm_a);      %���л����ѷ���ʱ��
col_amf_f=find_col('among_fail_time',itm_f);    %���ϻ��Ĺ���ǰ��������ʱ��

t1=zeros(size(raw_t,1),max(cell2mat(raw_t(:,col_fc_f))));      %�����ʱ��
t2=zeros(size(raw_t,1),max(cell2mat(raw_t(:,col_fc_f))));      %�����ǰ��������ʱ��
t3=zeros(size(raw_t,1),1);      %���ѷ���ʱ��

%һ�δ���һ̨����
for i=1:size(t1,1)
    t3(i,1)=raw_t{i,col_ut_f};
    for j=1:raw_t{i,col_fc_f}
        t1(i,j)=raw_t{i,col_ft_f}(j,1);  %���л����Ĺ���ʱ���,��ʾ��į�����ĵ�j�ι��ϵĹ���ʱ��
        t2(i,j)=raw_t{i,col_amf_f}(j,1); %���ϻ�����ǰ��������ʱ�� ,��ʾ��į�����ĵ�j�ι��ϵĹ���ǰ��������ʱ��       
    end
end
%f_count��Ϊ-1ʱ,Ҫ�ض�����,��ÿ�ι���������
%f_countΪ-1ʱ,���й��϶�Ҫ������,���Բ��ض�,��Ҫ���в���
if f_count~=-1
    max_fail_count=min(f_count,size(t1,2));
    t1=t1(:,[1:max_fail_count]);        %����Ҫ���������
    t2=t2(:,[1:max_fail_count]);
else
    max_fail_count=1;
end



%1.��ʼͳ��
x_ftime=1:max(max(t1));           %����ʱ��
y_mcount_start=zeros(length(x_ftime),max_fail_count);   %��i���·������ϵĻ���̨��(���ϼ�ʱ��Ϊ���)
y_mcount_last=zeros(length(x_ftime),max_fail_count);   %��i���·������ϵĻ���̨��(����һ�ι���Ϊ���)
% y_mcount_bf=zeros(length(x_ftime),max_fail_count);   %ǰi���·������ϵĻ���̨��
%1.1����ÿ�¹��ϻ�����
t4=reshape(t1,size(t1,1)*size(t1,2),1);
t5=reshape(t2,size(t2,1)*size(t2,2),1);
for i=1:length(x_ftime)
    if f_count~=-1
        for j=1:max_fail_count
            ind1=find(t1(:,j)==x_ftime(i));
            y_mcount_start(i,j)=length(ind1);        %����ʱ��Ļ�����
        end
    else
        ind1=find(t4(:,1)==x_ftime(i));     %��i���·����Ĺ�����(���ϼ�ʱ��Ϊ���)
        ind2=find(t5(:,1)==x_ftime(i));     %��i���·����Ĺ�����(����һ�ι���Ϊ���)
        y_mcount_start(i,1)=length(ind1);
        y_mcount_last(i,1)=length(ind2);
    end
end


%1.2�������ϼ�i���µ�Ӳ��/������
y_hdcount=zeros(max(x_ftime),1);        %��Ӳ������Ϊ��ĸ  
y_mcount=zeros(max(x_ftime),1);         %�Ի���̨����Ϊ��ĸ
for i=1:length(y_hdcount)
    ind=find(cell2mat(raw_a(:,col_ut_a))>i);          %�ϼ�ʱ�����i�Ļ�������
    if isempty(ind)
        continue;
    end
    ind=ind(find(cell2mat(raw_a(ind,col_ut_a))<96),1);    %8�����ϼܵĻ�������
    y_hdcount(i)=sum(num_hd(raw_a(ind,col_dc_a),num_dc));     %��Ӳ������Ϊ��ĸ
    y_mcount(i)=length(ind);                        %�Ի���̨����Ϊ��ĸ
end
width_yms=size(y_mcount_start,2);
len_yms=size(y_mcount_start,1);
f_rate_start=zeros(len_yms,width_yms);
f_rate_last=zeros(len_yms,width_yms);
for i=1:width_yms
    f_rate_start(:,i)=y_mcount_start(:,i)./y_hdcount;         %������(���ϼ�ʱ��Ϊ��׼)
    f_rate_last(:,i)=y_mcount_last(:,i)./y_hdcount;             %������(���ϴι���ʱ��Ϊ��׼)
end
f_rate_start=[x_ftime',f_rate_start];
f_rate_last=[x_ftime',f_rate_last];
if f_count==-1
    itm=[{'����ʱ��'},{'������'}];
else
    itm={'����ʱ��'};
    for i=1:max_fail_count
        str=['��' num2str(i) '�ι��Ϲ�����'];
        itm=cat(2,itm,str);
    end
end
f_rate_start=cat(1,itm,num2cell(f_rate_start));
f_rate_last=cat(1,itm,num2cell(f_rate_last));

ret_need=f_rate_start;
ret_all=[{f_rate_start},{f_rate_last},{y_hdcount},{y_mcount_start},{y_mcount_last}];



%1.3����ǰi���µĹ��ϻ�����
% for i=1:length(x_ftime)
%     for j=1:max_fail_count
%          %���ϼܳ�i���µĻ����й���ʱ��С��i���µ�����
%          ind1=find(t1(:,j)<=x_ftime(i));              %���ҹ���ʱ��С��i������
%          ind_t2=ind1(find(t2(ind1,j)>=x_ftime(i)));      %�ڴ˻����������ϼ�ʱ���ѳ���i���µ�
%         y_mcount_bf(i,j)=length(ind_t2);
%     end
% end


%ǰi���¹������ܺ�,����������岻��
% if size(y_mcount_bf,2)==1
%     y_mcount_bf=[y_mcount_bf,y_mcount_bf];
% else
%     y_mcount_bf=[y_mcount_bf,sum(y_mcount_bf')'];
% end
% y_mcount_bf=[x_ftime',y_mcount_bf];
% 
% if size(y_mcount_start,2)==1
%     y_mcount_start=[y_mcount_start,y_mcount_start];
% else
%     y_mcount_start=[y_mcount_start,sum(y_mcount_start')'];      %�ó������µ��ܹ�����
% end

% y_mcount_start=[x_ftime',y_mcount_start];        %����ʱ��-���ϴ���(���ϼ�ʱ��Ϊ��׼)
% y_mcount_last=[x_ftime',y_mcount_last];         %����ʱ��-���ϴ���(���ϴι���ʱ��Ϊ��׼)

% itm=[{'����ʱ��'},{'��1�ι���'},{'��2�ι���'},{'��3�ι���'},{'��4�ι���'},{'��5�ι���'}];
% itm1=[{'�ϼ�'},{'���ϼ�Ӳ����'},{'���ϼܻ�����'}];
% itm2=[{'����ʱ��'},{'��1�ι���'},{'��2�ι���'},{'��3�ι���'},{'��4�ι���'},{'��5�ι���'},{'�ϼ�'}];
% num1=size(y_mcount_start,2)-3;
% item1=cat(2,itm(1,[1:num1]),itm1);
% item2=itm2(1,[1:max_fail_count+1,end]);
% item3=itm2(1,[1:max_fail_count+1,end]);
% item4=itm2(1,[1:max_fail_count+1,end]);
% item5=itm2(1,[1:max_fail_count+1,end]);

% zzz=zeros(max(x_ftime),1);       %������1
% zzz(:,1)=x_ftime;
% zzz1=zeros(max(x_ftime),1);      %������2
% zzz1(:,1)=x_ftime;
% zzz2=zeros(max(x_ftime),1);      %������3
% zzz2(:,1)=x_ftime;
% for i=2:max_fail_count+1
%     zzz(:,i)=y_mcount_start(:,i)./y_hdcount([1:max(x_ftime)],1);
%     zzz1(:,i)=y_mcount_start(:,i)./y_mcount([1:max(x_ftime)],1);
%     zzz2(:,i)=y_mcount_bf(:,i)./y_hdcount([1:max(x_ftime)],1);
% end
% if size(zzz,2)==2
%     zzz=[zzz,zzz(:,end)];
%     zzz1=[zzz1,zzz1(:,end)];
%     zzz2=[zzz2,zzz2(:,end)];
% else
%     zzz=[zzz,sum(zzz(:,[2:end])')'];
%     zzz1=[zzz1,sum(zzz1(:,[2:end])')'];
%     zzz2=[zzz2,sum(zzz2(:,[2:end])')'];
% end
% 
% ret=[y_mcount_start,y_mcount_bf,zzz,zzz1,zzz2];
% r1={cat(1,item1,num2cell(y_mcount_start))};
% r2={cat(1,item2,num2cell(y_mcount_bf))};
% r3={cat(1,item3,num2cell(zzz))};
% r4={cat(1,item4,num2cell(zzz1))};
% r5={cat(1,item5,num2cell(zzz2))};
% ret1=[r1 r2 r3 r4 r5];
 
% yy=filter_infnan(yy);
% zzz=filter_infnan(zzz);
% zzz1=filter_infnan(zzz1);

% %���ʱ��
% t1=zeros(length(raw_t),10);
% for i=1:length(t1)
%     for j=1:min(raw_t{i,col_ntc}-1,10)
% %         t1(i,j)=round(cell2mat(raw_t{i,col_ntt}(j,2))/3)/10; %1λС��,��һ��������
%         t1(i,j)=cell2mat(raw_t{i,col_ntt}(j,2)); %1λС��,��һ��������
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