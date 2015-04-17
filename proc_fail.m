%故障统计与结果生成
%col和col_a是两个单中分类的字段,即所有结果是根据这两个字段进行分类的
%比如都选择业务列,得出的是各业务的各信息,选择机型列是得出各机型的各信息
%两个单的这一列如果是不变的 那给出的就是某个具体机型或业务的信息.比如我把非C1的机型过滤,再用过滤后的数据做为参数
%得出的就是C1的各项信息.当然,这里的限制条件要选机型列,如果选业务列那么得出的就是C1机型的各业务的数据
%若列数都为-1 那么就分析所有单

%输入:
%故障单(汇总为机器,每台机器所有故障为一行),故障单(每次故障为一行),故障单的限制列,总单,总单限制列,机型具体配件文件,机型配置总单的字段名,故障单的字段名
%输出(每一类一行):
%故障次数,故障台数,机器台数,硬盘总台数,故障机平均服役时间,总台数平均服役时间,故障次数占硬盘总台数比,故障台数占机器台数比
%故障率1,故障率2,故障台占比,平均故障次数
%前五次故障时间的故障台数,前i个月的故障次数,故障率(硬盘),故障率(台数),累积故障率(前i个月的故障率)
function [ret ret_raw itm]=proc_fail(raw_t,raw_f,col,raw_a,col_a,num_dc,itm_a,itm_f)
tic;
ret=1;
col_num_f=find_col('fail_count',itm_f);     %故障单中故障次数的列数
col_time_f=find_col('fail_time',itm_f);      %故障时的已服役时间
col_time_a=find_col('used_time',itm_a);      %总单中已服役时间
col_dc_a=find_col('dev_class_name',itm_a);     %总单中
enable_fu=1; %为1则计算前i次故障的台数次数,故障率等
f_count=ones(5,1)*2;      %记录故障次数

%若为-1的处理方式
flag_col=0;
if col==-1 || col_a==-1
    flag_col=-1;
    raw_t=cat(2,raw_t,cellstr(num2str(zeros(size(raw_t,1),1))));
    raw_f=cat(2,raw_f,cellstr(num2str(zeros(size(raw_f,1),1))));
    raw_a=cat(2,raw_a,cellstr(num2str(zeros(size(raw_a,1),1))));
    col=size(raw_t,2);
    col_a=size(raw_a,2);
end

%数字类型的处理->转化为字符(因为unique要处理cellstr类型数据)
if isa(raw_t{1,col},'double')
    if isa(cell2mat(raw_t(:,col)),'double')
        raw_t(:,col)=cellstr(num2str(cell2mat(raw_t(:,col))));
    end
    if isa(cell2mat(raw_f(:,col)),'double')
        raw_f(:,col)=cellstr(num2str(cell2mat(raw_f(:,col))));
    end
    if isa(cell2mat(raw_a(:,col_a)),'double')
        raw_a(:,col_a)=cellstr(num2str(cell2mat(raw_a(:,col_a))));
    end
end

uni=unique(raw_t(:,col));
uni=uni([1:end],:);
ind_noneed=find(strcmp(uni,'###')==1);
if ~isempty(ind_noneed) && length(uni)==1
    return ;
end
uni(ind_noneed,:)=[];   %去掉###的行
len=length(uni);
len_a=length(raw_a);
ret=cell(len,10);
h=waitbar(0,'function-procfail');
last=11;
%一类一类的处理
for i=1:len
    waitbar(i/len,h,strcat('function-procfail: ',uni{i}));
    ind1=find(strcmp(uni{i},raw_t(:,col)));     %某类故障台数
    ind2=find(strcmp(uni{i},raw_a(:,col_a)));   %某类机器台数
    ind3=find(strcmp(uni{i},raw_f(:,col)));     %某类故障单数
    if isempty(ind1)||isempty(ind2)|| isempty(ind3)
        continue;
    end
    ret{i,1}=length(ind3);      %故障次数
    ret{i,2}=length(ind1);          %故障台数
    ret{i,3}=length(ind2);          %机器台数
    ret{i,4}=sum(num_hd(raw_a(ind2,col_dc_a),num_dc));  %硬盘总台数
    
    a=raw_t(ind1,:);
    b=raw_a(ind2,:);
    c=raw_f(ind3,:);
    ret{i,10}=mean(cell2mat(raw_t(ind1,col_time_f)));         %故障机平均服役时长,这个时间应该是故障时的已服役时长
    ret{i,11}=mean(cell2mat(raw_a(ind2,col_time_a)));      %总机平均服役时间
    if enable_fu==1
         [ne ret{i,last+1}]=...
             reg_frate(c,a,b,num_dc,itm_f,itm_a,f_count(1));
         
          [ne ret{i,last+2}]=...
             fail_frate(c,a,b,num_dc,itm_f,itm_a,f_count(2));
         
          [ret{i,last+3}]=...
             mttf_mnum(c,a,b,num_dc,itm_f,itm_a,f_count(3));
         
          [ne ret{i,last+4}]=...
             mttf_frate(c,a,b,num_dc,itm_f,itm_a,f_count(4));
         
         ret{i,last+5}=fnum(c,a,b,num_dc,itm_f,itm_a);
         
		  [ret{i,last+6}]=...
             mon_frate(c,a,b,num_dc,itm_f,itm_a,f_count(5));
    end
%     if enable_fu==1
%         [out1a out1b]=ftime(a,b,f_count,num_dc,itm_f,itm_a);
%          ret{i,last+1}=out1b{1};
%          ret{i,last+2}=out1b{2};
%          ret{i,last+3}=out1b{3};
%          ret{i,last+4}=out1b{4};
%          ret{i,last+5}=out1b{5};
%         [out1c ret{i,last+6}]=utime(c,b,num_dc,itm_f,itm_a);
%     end


    
end
ret(:,5)=num2cell(cell2mat(ret(:,1))./cell2mat(ret(:,4)));    %故障率1
ret(:,6)=num2cell(cell2mat(ret(:,2))./cell2mat(ret(:,4)));    %故障率2
ret(:,7)=num2cell(cell2mat(ret(:,2))./cell2mat(ret(:,3)));    %故障台占比
ret(:,8)=num2cell(cell2mat(ret(:,1))./cell2mat(ret(:,2)));    %平均故障次数
up=cell2mat(ret(:,8));down=cell2mat(ret(:,7));
% up=up/sum(up);down=down/sum(down);
ret(:,9)=num2cell(up./down);    %故障密度


ret=cat(2,uni,ret);
if flag_col~=-1
    tp=itm_a(1,col_a);
else
    tp='all';
end
if enable_fu==1
    itm=[{tp},{'故障次数'},{'故障台数'},{'机器台数'},{'硬盘总数'},{'故障率(故障次数/硬盘总数)'},...
        {'故障率(故障台数/硬盘总数)'},...
        {'占比(故障台数/机器台数)'},{'平均故障次数(故障次数/故障台数)'},{'故障密度(占比/平均故障次数)'},...
        {'故障机平均服役时间'},{'总机平均服役时间'},...
        {'上架时间-故障率'},{'故障时刻-上架时间分布'},{'无故障时间-机器台数'},...
        {'服役时间-故障率'},{'故障次数-机器台数'},{'每月故障率'}];
else
    itm=[{tp},{'故障次数'},{'故障台数'},{'机器台数'},{'硬盘总数'},{'故障率(故障次数/硬盘总数)'},...
        {'故障率(故障台数/硬盘总数)'},...
        {'占比(故障台数/机器台数)'},{'平均故障次数(故障次数/故障台数)'},{'故障密度(占比/平均故障次数)'},...
        {'故障机平均服役时间'},{'总机平均服役时间'}];
end
% if enable_fu==1
%     itm=[{tp},{'故障次数'},{'故障台数'},{'机器台数'},{'硬盘总数'},{'故障率(故障次数/硬盘总数)'},...
%         {'故障率(故障台数/硬盘总数)'},...
%         {'占比(故障台数/机器台数)'},{'平均故障次数(故障次数/故障台数)'},{'故障密度(占比/平均故障次数)'},...
%         {'故障机平均服役时间'},{'总机平均服役时间'},...
%         {'故障时间-故障台数'},{'故障时间-故障台数[前n个月]'},{'故障时间-故障率(硬盘)'},...
%         {'故障时间-故障率(台数)'},{'故障时间-故障率(硬盘)[前n个月]'},{'上架时间-信息'}];
% else
%     itm=[{tp},{'故障次数'},{'故障台数'},{'机器台数'},{'硬盘总数'},{'故障率(故障次数/硬盘总数)'},...
%         {'故障率(故障台数/硬盘总数)'},...
%         {'占比(故障台数/机器台数)'},{'平均故障次数(故障次数/故障台数)'},{'故障密度(占比/平均故障次数)'},...
%         {'故障机平均服役时间'},{'总机平均服役时间'}];
% end
ret_raw=ret;
ret=cat(1,itm,ret);
toc;
close(h);