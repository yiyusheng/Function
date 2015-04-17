%计算服役时间与故障率的关系,实际上对于第一次故障来说是无故障时间,根据无故障时间的分类.
%但是对于第二次故障来说,这不能算是无故障时间了.因为第二次故障的无故障时间应该是二次故障时刻减一次故障时刻
%所以机器服役时间是准确的,只是用mttf这个term.
%故障时服役时间就是我们之前计算出的在raw_f中的故障时间fail_time
function [retall retset]=mttf_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('mttf_frate processing......');
    col_ft_f=find_col('fail_time',itm_f);      %故障机器的故障时间列
    col_ut_f=find_col('used_time',itm_f);      %故障机已服役时间
    col_ut_a=find_col('used_time',itm_a);      %所有机器已服役时间
    col_fc_f=find_col('fail_count',itm_f);      %故障机发生故障次数
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end

    %提取第i次故障的故障时间数据
    fail_count_t=cell2mat(raw_t(:,col_fc_f));
    data_regfail=cell(fc+1,1);     %前f_count放的每一次故障的数据,后面一次放的总的
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %这里要注意
        for j=1:length(ind_fc)
            failtime_fc=raw_t{ind_fc(j),col_ft_f}(i);   %第i次故障的故障时间
            regtime_fc=raw_t{ind_fc(j),col_ut_f};       %对应的服役时间
            data_regfail{i,1}=[data_regfail{i,1};
                failtime_fc,regtime_fc];
        end
    end
    %提取所有机器的故障时间数据
    data_regfail{end,1}=[cell2mat(raw_f(:,col_ft_f)),...
        cell2mat(raw_f(:,col_ut_f))];   %在本程序中第二列没有用上 
    regtime_a=cell2mat(raw_a(:,col_ut_a));  
    max_regtime=max(regtime_a);     %最大最小的服役时间
    min_regtime=min(regtime_a);
    
    
    retset=cell(size(data_regfail,1),3);
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);  %故障时的已服役时间,用这个分类
        regtime_f=data_regfail{i,1}(:,2);   %上架时间
        max_failtime=max(failtime_f);   %求最大最小的故障时间
        min_failtime=min(failtime_f);
        ret_numer=zeros((max_failtime-min_failtime+1),1);   %分子
        ret_denomi=zeros((max_failtime-min_failtime+1),1);   %分母
        %分母,根据故障时间大小记录,只有一列
        for j=min_failtime:max_failtime
            ret_denomi(j-min_failtime+1,1)=length(find(regtime_a>=j));  %等于号要取到
        end
        %计算分子
        %行:从上架第一个月的故障率开始计算.
        %因为这里算的是故障时的服役时间.所以是从最小的故障时间开始算
        for j=min_failtime:max_failtime
            ind_f=find(failtime_f==j);  %故障时刻为j的故障单
            ret_numer(j-min_failtime+1,1)=length(ind_f);
        end
        ret=ret_numer./ret_denomi; 
        ret=[(min_failtime:max_failtime)',ret];  %加一行表示每列为故障时间
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    retall=retset{end,1};
    toc;
end