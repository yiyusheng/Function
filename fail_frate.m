%根据故障时间分类,每一行代表一个月的故障,这个月发生故障机器上架时间的分布.
function [retall retset]=fail_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('fail_frate processing......');
    from=datevec('2013/11/01');
    col_ft_f=find_col('fail_time',itm_f);      %故障机器的故障时间列
    col_ut_f=find_col('used_time',itm_f);      %故障机已服役时间
    col_ut_a=find_col('used_time',itm_a);      %所有机器已服役时间
    col_fc_f=find_col('fail_count',itm_f);      %故障机发生故障次数
    col_ct_f=find_col('create_time',itm_f);     %故障发生的绝对时间
    col_svrid_f=find_col('svr_asset_id',itm_f); %故障机标识
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end
    
    %提取第i次故障的绝对时间,用2013/11/01-故障时刻
    fail_count_t=cell2mat(raw_t(:,col_fc_f));   %计算每台机器的故障次数
    data_regfail=cell(fc+2,1);     
    %前f_count放的每一次故障的数据,后面一次放的总的(分是否把同一台机器在同一个月的故障合并)
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %只有故障次数大于i的机器才有第i次故障的时刻
        for j=1:length(ind_fc)
            %使用2013/12/10减去故障时刻作为故障时间
            if isa(raw_t{ind_fc(j),col_ct_f},'cell')
                failtime_ct=datevec(raw_t{ind_fc(j),col_ct_f}(i));
            elseif isa(raw_t{ind_fc(j),col_ct_f},'char')
                failtime_ct=datevec(raw_t{ind_fc(j),col_ct_f});
            end
            failtime_fc=(from(1)-failtime_ct(1))*12+(from(2)-failtime_ct(2))+...
                ceil((from(3)-failtime_ct(3))/30);
            regtime_fc=raw_t{ind_fc(j),col_ut_f};
            data_regfail{i,1}=[data_regfail{i,1};
                failtime_fc,regtime_fc];
        end
    end
    %提取所有故障机器的故障时间数据
    failtime_ct=datevec(raw_f(:,col_ct_f));
    o=ones(size(failtime_ct,1),1);
    failtime_fc=(from(1)*o-failtime_ct(:,1))*12+...
        (from(2)*o-failtime_ct(:,2))+...
        ceil((from(3)*o-failtime_ct(:,3))/30);
    data_regfail{end-1,1}=[failtime_fc,cell2mat(raw_f(:,col_ut_f))];
    data_regfail{end,1}=[failtime_fc,cell2mat(raw_f(:,col_ut_f))]; 
    %所有机器的上架时间
    regtime_a=cell2mat(raw_a(:,col_ut_a));
    %计算最大最小上架时间
    max_regtime=max(regtime_a);
    min_regtime=min(regtime_a);
    %因为每一行的分母是一样的,先计算出来
    row_denomi=zeros(1,max_regtime-min_regtime+1);
    %列:上架时间从45月前开始,到1个月前
    for i=max_regtime:-1:min_regtime
        ind_a=find(regtime_a==i);
        row_denomi(1,max_regtime-i+1)=length(ind_a);
    end
    
    %根据故障时刻对故障机进行分类.
    retset=cell(size(data_regfail,1),3);
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);  %这个已经是故障时刻,称为故障时间
        regtime_f=data_regfail{i,1}(:,2);   %上架时间
        max_failtime=max(failtime_f);   %求最大最小的故障时间
        min_failtime=min(failtime_f);
        ret_numer=zeros((max_failtime-min_failtime+1),max_regtime-min_regtime+1);   %分子
        ret_denomi=zeros((max_failtime-min_failtime+1),max_regtime-min_regtime+1);   %分母
        %装入分母
        for j=1:size(ret_denomi,1)
            ret_denomi(j,:)=row_denomi;
        end
        %计算分子
        %行:从45个月前的故障开始.
        for j=max_failtime:-1:min_failtime
            ind_f=find(failtime_f==j);  %故障时刻为j的故障单
            %对于所有单,同一个月发生多次故障的机器,只认为发生过一次故障.结果存在最后
            if i==size(data_regfail,1)
                uni_svrid=unique(raw_f(ind_f,col_svrid_f));
                [~,~,ind_f1]=intersect(uni_svrid,raw_f(ind_f,col_svrid_f));
                ind_f=ind_f(ind_f1);
            end
            %列:从45月前开始    
            for k=max_regtime:-1:min_regtime
                fail_reg_f=regtime_f(ind_f);    %某月发生的故障对应的上架时间
                ret_numer(max_failtime-j+1,max_regtime-k+1)=length(find(fail_reg_f==k));
            end
        end
%         for j=min_failtime:max_failtime
%             ind_f=find(failtime_f==j);  %故障时刻为j的故障单
%             %对于所有单,同一个月发生多次故障的机器,只认为发生过一次故障.结果存在最后
%             if i==size(data_regfail,1)
%                 uni_svrid=unique(raw_f(ind_f,col_svrid_f));
%                 [~,~,ind_f1]=intersect(uni_svrid,raw_f(ind_f,col_svrid_f));
%                 ind_f=ind_f(ind_f1);
%             end
%             %列:从45月前开始    
%             for k=max_regtime:-1:min_regtime
%                 fail_reg_f=regtime_f(ind_f);    %某月发生的故障对应的上架时间
%                 ret_numer(j-min_failtime+1,max_regtime-k+1)=length(find(fail_reg_f==k));
%             end
%         end
        ret=ret_numer./ret_denomi; 
        ret=[min_regtime:max_regtime;ret];  %加一行表示每列为上架时间的分布
        ret=[[-1,min_failtime:max_failtime]',ret];
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    retall=retset{end,1};
    toc;
end