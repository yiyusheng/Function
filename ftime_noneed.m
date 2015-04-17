%计算故障时间与故障的关系
%输入为故障单和总单
% y_mcount_start为以上架时间为标准计算故障时间得到的每个周期的故障次数
% y_mcount_last为以上次故障时间为标准计算故障时间得到的每个周期的故障次数
% x_ftime为故障时间
% y_hdcount为以上架时间为标准计算的已上架i个月的硬盘数
% y_mcount为以上架时间为标准计算的已上架i个月的机器数
%f_count为统计的故障次数,如第n个月发生第m次故障的故障率,若f_count=-1则统计所有故障.不统计次数
function [ret_need ret_all]=ftime_1(raw_t,raw_a,f_count,num_dc,itm_f,itm_a)
col_fc_f=find_col('fail_count',itm_f);     %故障单中一台机器出现的故障数
col_ft_f=find_col('fail_time',itm_f);      %故障机器的故障时间列
col_dc_a=find_col('dev_class_name',itm_a);      %机型所在列,用于计算硬盘数
col_ut_f=find_col('used_time',itm_f);      %故障机已服役时间
col_ut_a=find_col('used_time',itm_a);      %所有机器已服役时间
col_amf_f=find_col('among_fail_time',itm_f);    %故障机的故障前正常运行时间

t1=zeros(size(raw_t,1),max(cell2mat(raw_t(:,col_fc_f))));      %存故障时间
t2=zeros(size(raw_t,1),max(cell2mat(raw_t(:,col_fc_f))));      %存故障前正常运行时间
t3=zeros(size(raw_t,1),1);      %存已服役时间

%一次处理一台机器
for i=1:size(t1,1)
    t3(i,1)=raw_t{i,col_ut_f};
    for j=1:raw_t{i,col_fc_f}
        t1(i,j)=raw_t{i,col_ft_f}(j,1);  %所有机器的故障时间表,表示第i台机器的第j次故障的故障时间
        t2(i,j)=raw_t{i,col_amf_f}(j,1); %故障机故障前正常运行时间 ,表示第i台机器的第j次故障的故障前正常运行时间       
    end
end
%f_count不为-1时,要截断数据,按每次故障来处理
%f_count为-1时,所有故障都要被考虑,所以不截断,不要进行操作
if f_count~=-1
    max_fail_count=min(f_count,size(t1,2));
    t1=t1(:,[1:max_fail_count]);        %把需要的数据提出
    t2=t2(:,[1:max_fail_count]);
else
    max_fail_count=1;
end



%1.开始统计
x_ftime=1:max(max(t1));           %故障时间
y_mcount_start=zeros(length(x_ftime),max_fail_count);   %第i个月发生故障的机器台数(以上架时间为起点)
y_mcount_last=zeros(length(x_ftime),max_fail_count);   %第i个月发生故障的机器台数(以上一次故障为起点)
% y_mcount_bf=zeros(length(x_ftime),max_fail_count);   %前i个月发生故障的机器台数
%1.1计算每月故障机器数
t4=reshape(t1,size(t1,1)*size(t1,2),1);
t5=reshape(t2,size(t2,1)*size(t2,2),1);
for i=1:length(x_ftime)
    if f_count~=-1
        for j=1:max_fail_count
            ind1=find(t1(:,j)==x_ftime(i));
            y_mcount_start(i,j)=length(ind1);        %故障时间的机器数
        end
    else
        ind1=find(t4(:,1)==x_ftime(i));     %第i个月发生的故障数(以上架时间为起点)
        ind2=find(t5(:,1)==x_ftime(i));     %第i个月发生的故障数(以上一次故障为起点)
        y_mcount_start(i,1)=length(ind1);
        y_mcount_last(i,1)=length(ind2);
    end
end


%1.2计算已上架i个月的硬盘/机器数
y_hdcount=zeros(max(x_ftime),1);        %以硬盘数做为分母  
y_mcount=zeros(max(x_ftime),1);         %以机器台数作为分母
for i=1:length(y_hdcount)
    ind=find(cell2mat(raw_a(:,col_ut_a))>i);          %上架时间大于i的机器索引
    if isempty(ind)
        continue;
    end
    ind=ind(find(cell2mat(raw_a(ind,col_ut_a))<96),1);    %8年内上架的机器索引
    y_hdcount(i)=sum(num_hd(raw_a(ind,col_dc_a),num_dc));     %以硬盘数做为分母
    y_mcount(i)=length(ind);                        %以机器台数作为分母
end
width_yms=size(y_mcount_start,2);
len_yms=size(y_mcount_start,1);
f_rate_start=zeros(len_yms,width_yms);
f_rate_last=zeros(len_yms,width_yms);
for i=1:width_yms
    f_rate_start(:,i)=y_mcount_start(:,i)./y_hdcount;         %故障率(以上架时间为标准)
    f_rate_last(:,i)=y_mcount_last(:,i)./y_hdcount;             %故障率(以上次故障时间为标准)
end
f_rate_start=[x_ftime',f_rate_start];
f_rate_last=[x_ftime',f_rate_last];
if f_count==-1
    itm=[{'故障时间'},{'故障率'}];
else
    itm={'故障时间'};
    for i=1:max_fail_count
        str=['第' num2str(i) '次故障故障率'];
        itm=cat(2,itm,str);
    end
end
f_rate_start=cat(1,itm,num2cell(f_rate_start));
f_rate_last=cat(1,itm,num2cell(f_rate_last));

ret_need=f_rate_start;
ret_all=[{f_rate_start},{f_rate_last},{y_hdcount},{y_mcount_start},{y_mcount_last}];



%1.3计算前i个月的故障机器数
% for i=1:length(x_ftime)
%     for j=1:max_fail_count
%          %已上架超i个月的机器中故障时间小于i个月的数量
%          ind1=find(t1(:,j)<=x_ftime(i));              %先找故障时间小于i的索引
%          ind_t2=ind1(find(t2(ind1,j)>=x_ftime(i)));      %在此基础上再找上架时间已超过i个月的
%         y_mcount_bf(i,j)=length(ind_t2);
%     end
% end


%前i个月故障率总和,这个求了意义不大
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
%     y_mcount_start=[y_mcount_start,sum(y_mcount_start')'];      %得出各个月的总故障数
% end

% y_mcount_start=[x_ftime',y_mcount_start];        %故障时间-故障次数(以上架时间为标准)
% y_mcount_last=[x_ftime',y_mcount_last];         %故障时间-故障次数(以上次故障时间为标准)

% itm=[{'故障时间'},{'第1次故障'},{'第2次故障'},{'第3次故障'},{'第4次故障'},{'第5次故障'}];
% itm1=[{'合计'},{'已上架硬盘数'},{'已上架机器数'}];
% itm2=[{'故障时间'},{'第1次故障'},{'第2次故障'},{'第3次故障'},{'第4次故障'},{'第5次故障'},{'合计'}];
% num1=size(y_mcount_start,2)-3;
% item1=cat(2,itm(1,[1:num1]),itm1);
% item2=itm2(1,[1:max_fail_count+1,end]);
% item3=itm2(1,[1:max_fail_count+1,end]);
% item4=itm2(1,[1:max_fail_count+1,end]);
% item5=itm2(1,[1:max_fail_count+1,end]);

% zzz=zeros(max(x_ftime),1);       %故障率1
% zzz(:,1)=x_ftime;
% zzz1=zeros(max(x_ftime),1);      %故障率2
% zzz1(:,1)=x_ftime;
% zzz2=zeros(max(x_ftime),1);      %故障率3
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

% %间隔时间
% t1=zeros(length(raw_t),10);
% for i=1:length(t1)
%     for j=1:min(raw_t{i,col_ntc}-1,10)
% %         t1(i,j)=round(cell2mat(raw_t{i,col_ntt}(j,2))/3)/10; %1位小数,这一行有问题
%         t1(i,j)=cell2mat(raw_t{i,col_ntt}(j,2)); %1位小数,这一行有问题
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