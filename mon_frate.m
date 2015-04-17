%计算集合中机器的每月故障率,从上架第一个月开始
%只有一类,不分故障次数.分子为某月发生故障的故障次数,分母为某月已上架的机器数对应的硬盘数
function retset=mon_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    from=datevec('2013/11/01');
    disp('mon_frate processing......');
    col_ft_f=find_col('fail_time',itm_f);      %故障机器的故障时间列
    col_ut_f=find_col('used_time',itm_f);      %故障机已服役时间
    col_ut_a=find_col('used_time',itm_a);      %所有机器已服役时间
    col_fc_f=find_col('fail_count',itm_f);      %故障机发生故障次数
    col_ct_f=find_col('create_time',itm_f);     %故障机故障发生时刻
    col_dc_a=find_col('dev_class_name',itm_a);  %机型列用于求硬盘数
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end

    %提取第i次故障的故障绝对数据
    fail_count_t=cell2mat(raw_t(:,col_fc_f));
    data_regfail=cell(fc+1,1);     %前f_count放的每一次故障的数据,后面一次放的总的
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %这里要注意
        %使用2013/11/01减去故障时刻作为故障时间
        for j=1:size(ind_fc,1)
            if isa(raw_t{ind_fc(j),col_ct_f},'cell')
                failtime_ct=datevec(raw_t{ind_fc(j),col_ct_f}(i));
            elseif isa(raw_t{ind_fc(j),col_ct_f},'char')
                failtime_ct=datevec(raw_t{ind_fc(j),col_ct_f});
            end
            failtime_fc=(from(1)-failtime_ct(1))*12+(from(2)-failtime_ct(2))+...
                ceil((from(3)-failtime_ct(3))/31);
            regtime_fc=raw_t{ind_fc(j),col_ut_f};
            data_regfail{i,1}=[data_regfail{i,1};failtime_fc,regtime_fc];
        end
    end
    %提取所有机器的故障时间数据
    failtime_ct=datevec(raw_f(:,col_ct_f));
    o=ones(size(failtime_ct,1),1);
    failtime_fc=(from(1)*o-failtime_ct(:,1))*12+(from(2)*o-failtime_ct(:,2))+...
            ceil((from(3)*o-failtime_ct(:,3))/31);
    data_regfail{end,1}=[failtime_fc,...
        cell2mat(raw_f(:,col_ut_f))];   %在本程序中第二列没有用上 
    regtime_a=cell2mat(raw_a(:,col_ut_a));  
    max_regtime=max(regtime_a);     %最大最小的服役时间
    min_regtime=min(regtime_a);
    
    
    retset=cell(size(data_regfail,1),3);
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);  %故障时的绝对时间=1101-故障时间
        regtime_f=data_regfail{i,1}(:,2);   %上架时间
        max_failtime=max(failtime_f);   %求最大最小的故障时间
        min_failtime=min(failtime_f);
        ret_numer=zeros((max_regtime-min_regtime+1),1);   %分子
        ret_denomi=zeros((max_regtime-min_regtime+1),1);   %分母
        %分母,根据上架时间大小记录,只有一列
        for j=max_regtime:-1:min_regtime
            ind_denomi=find(regtime_a>=j);%等于号要取到
            ret_denomi(max_regtime-j+1,1)=...
                sum(num_hd(raw_a(ind_denomi,col_dc_a),num_dc));
        end
        %计算分子
        %行:从上架第一个月的故障率开始计算.
        for j=max_regtime:-1:min_regtime
            ind_f=find(failtime_f==j);  %故障时刻为j的故障单
            ret_numer(max_regtime-j+1,1)=length(ind_f);
        end
        ret=ret_numer./ret_denomi; 
        ret=[(min_regtime:max_regtime)',ret];  %加一行表示每列为故障时间
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    
    toc;
end