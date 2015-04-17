%求上架时间与故障率的关系.
%根据上架时间(已服役时间)对所有故障机分类,求出每个月上架的机器的在上架之后每个月的故障率.
%输入:故障单,故障机,总机,硬盘统计,故障单目录,总机目录,计算几次故障
%输出:retall是所有故障的上架时间与故障率关系,每一行第一个元素代表这一行表示的是第i个月前上架的机器
%retset是分第i次故障的,从上到分是第i次故障的数据.最后一列是所有故障的.
function [retall retset]=reg_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('reg_frate processing......');
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
        ind_fc=find(fail_count_t>=i);   %因为大于等于i才有第i次故障.才能取到第i个元素
        for j=1:length(ind_fc)
            failtime_fc=raw_t{ind_fc(j),col_ft_f}(i);
            regtime_fc=raw_t{ind_fc(j),col_ut_f};
            data_regfail{i,1}=[data_regfail{i,1};
                failtime_fc,regtime_fc];
        end
    end
    %提取所有机器的故障时间数据
    data_regfail{end,1}=[cell2mat(raw_f(:,col_ft_f)),...
        cell2mat(raw_f(:,col_ut_f))];
    regtime_a=cell2mat(raw_a(:,col_ut_a));  
    max_regtime=max(regtime_a);
    min_regtime=min(regtime_a);
    max_failtime=max(data_regfail{end,1}(:,1));
    min_failtime=min(data_regfail{end,1}(:,1));
    
    retset=cell(size(data_regfail,1),3);
    %根据上架时间对故障机进行分类
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);
        regtime_f=data_regfail{i,1}(:,2);
        len_r=max_regtime-min_regtime+1;    %行数
        len_c=max_failtime-min_failtime+1; 
        ret_numer=zeros(len_r,max_regtime+1);   %分子
        ret_denomi=zeros(len_r,max_regtime+1);   %分母
        %行:根据上架时刻,从前到后
        for j=max_regtime:-1:min_regtime
            ind_a=find(regtime_a==j);   %服役时间为i的机器
            ind_f=find(regtime_f==j);   %服役时间为i的故障单
            ret_denomi(max_regtime-j+1,:)=length(ind_a);    %分母,一行全为同一个值,从第一行开始
            %服役时间小于j的机器,故障时间也必小于j,行列都为从1开始的顺序的绝对时间,
            %因为服役时间为j的机器,故障时间小于等于j,所以只要循环的j
            for k=0:j
                ind_ft_f=find(failtime_f(ind_f)==k);     %服役时间为i的故障单中,故障时间为j的单的索引
                %一行前面应该有max_regtime-j个0,而k从0开始,所有要+1
                ret_numer(max_regtime-j+1,(max_regtime-j)+k+1)=length(ind_ft_f);
            end
        end
        ret=ret_numer./ret_denomi; 
        ret=[0:max_regtime;ret];
        ret=[[-1,min_regtime:max_regtime]',ret];
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    retall=retset{end,1};
    toc;
end