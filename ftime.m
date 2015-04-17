%计算故障时间与故障的关系
%输入为故障单和总单
%yy为故障时间-各次故障的故障台数-合次故障台数,已上架i个月的硬盘数,已上架i个月的机器数
%yy1已上架超i个月的机器中故障时间小于i的故障次数及合计
%zzz为故障时间-故障率(硬盘数)
%zzz1为故障时间-故障率(机器台数)
%zzz2为故障时间-故障率(硬盘数)[分子为分母中前故障时间小于i个月的个数]
function [ret ret_all]=ftime(raw_time,raw_a,f_count,num_dc,itm_f,itm_a)
col_fn_f=find_col('fail_count',itm_f);     %故障单中一台机器出现的故障数
col_ft_f=find_col('fail_time',itm_f);      %故障机器的故障时间列
col_dc_a=find_col('dev_class_name',itm_a);      %机型所在列
col_ut_f=find_col('used_time',itm_f);      %故障机已服役时间
col_ut_a=find_col('used_time',itm_a);      %所有机器已服役时间
t1=zeros(size(raw_time,1),max(cell2mat(raw_time(:,col_fn_f))));      %所有数据,再过滤
t2=zeros(size(raw_time,1),max(cell2mat(raw_time(:,col_fn_f))));      %行为机器,列为故障次数
for i=1:size(t1,1)
    for j=1:min(size(t1,2),raw_time{i,col_fn_f})
        t1(i,j)=raw_time{i,col_ft_f}(j,1);  %所有机器的故障时间表,表示第i台机器的第j次故障的故障时间
        t2(i,j)=raw_time{i,col_ut_f};             %故障机的已上架时间
    end
end
f_count=min(f_count,size(t1,2));
t=t1(:,[1:f_count]);        %把需要的数据提出
t2=t2(:,[1:f_count]);

xx=1:max([max(t),1]);           %故障时间
yy=zeros(length(xx),f_count);   %第i个月发生故障的机器台数
yy1=zeros(length(xx),f_count);   %前i个月发生故障的机器台数
% waitbar(0.25,);
for i=1:length(xx)
    for j=1:f_count
        ind1=find(t(:,j)==xx(i));
        yy(i,j)=length(ind1);        %故障时间的机器数
    end
end
for i=1:length(xx)
    for j=1:f_count
         %已上架超i个月的机器中故障时间小于i个月的数量
         ind1=find(t(:,j)<=xx(i));              %先找故障时间小于i的索引
         ind_t2=ind1(find(t2(ind1,j)>=xx(i)));      %在此基础上再找上架时间已超过i个月的
        yy1(i,j)=length(ind_t2);
    end
end


zz=zeros(max(xx),1);
zz1=zeros(max(xx),1);
% waitbar(0.5,h);
for i=1:length(zz)
%     waitbar(0.5+i*0.5/length(zz));
    ind=find(cell2mat(raw_a(:,col_ut_a))>i);          %上架时间大于i的机器索引
    if isempty(ind)
        continue;
    end
    ind=ind(find(cell2mat(raw_a(ind,col_ut_a))<96),1);    %8年内上架的机器索引
    zz(i)=sum(num_hd(raw_a(ind,col_dc_a),num_dc));     %以硬盘数做为分母
    zz1(i)=length(ind);                        %以机器台数作为分母
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
    yy=[yy,sum(yy')'];      %得出各个月的故障数
end
yy=[xx',yy];        %故障时间-机器台数
yy=[yy,zz,zz1]; %把硬盘数,机器台数加入
itm=[{'故障时间'},{'第1次故障'},{'第2次故障'},{'第3次故障'},{'第4次故障'},{'第5次故障'}];
itm1=[{'合计'},{'已上架硬盘数'},{'已上架机器数'}];
itm2=[{'故障时间'},{'第1次故障'},{'第2次故障'},{'第3次故障'},{'第4次故障'},{'第5次故障'},{'合计'}];
num1=size(yy,2)-3;
item1=cat(2,itm(1,[1:num1]),itm1);
item2=itm2(1,[1:f_count+1,end]);
item3=itm2(1,[1:f_count+1,end]);
item4=itm2(1,[1:f_count+1,end]);
item5=itm2(1,[1:f_count+1,end]);

zzz=zeros(max(xx),1);       %故障率1
zzz(:,1)=xx;
zzz1=zeros(max(xx),1);      %故障率2
zzz1(:,1)=xx;
zzz2=zeros(max(xx),1);      %故障率3
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
ret_all=[r1 r2 r3 r4 r5];
 
% yy=filter_infnan(yy);
% zzz=filter_infnan(zzz);
% zzz1=filter_infnan(zzz1);

% %间隔时间
% t1=zeros(length(raw_time),10);
% for i=1:length(t1)
%     for j=1:min(raw_time{i,col_ntc}-1,10)
% %         t1(i,j)=round(cell2mat(raw_time{i,col_ntt}(j,2))/3)/10; %1位小数,这一行有问题
%         t1(i,j)=cell2mat(raw_time{i,col_ntt}(j,2)); %1位小数,这一行有问题
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