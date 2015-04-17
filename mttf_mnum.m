%计算无故障时间与机器台数的关系
%不分所有的,只计算第i次故障前无故障时间
function ret=mttf_mnum(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('mttf_mnum processing......');
%     from=datevec('2013/11/01');
%     col_ft_f=find_col('fail_time',itm_f);      %故障机器的故障时间列
%     col_ut_f=find_col('used_time',itm_f);      %故障机已服役时间
%     col_ut_a=find_col('used_time',itm_a);      %所有机器已服役时间
%     col_udt_f=find_col('use_time',itm_f);       %故障机上架时刻
    col_fc_f=find_col('fail_count',itm_f);      %故障机发生故障次数
%     col_ct_f=find_col('create_time',itm_f);     %故障发生的绝对时间
%     col_svrid_f=find_col('svr_asset_id',itm_f); %故障机标识
    col_af_f=find_col('among_fail_time',itm_f); %无故障时间列
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end
    
    %提取故障时刻
    fail_count_t=cell2mat(raw_t(:,col_fc_f));   %计算每台机器的故障次数
    data_regfail=cell(fc,1);     
    %存储前n次故障前的无故障时间
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %只有故障次数大于i的机器才有第i次故障的时刻
        for j=1:length(ind_fc)
            data_regfail{i,1}=[data_regfail{i,1};raw_t{ind_fc(j),col_af_f}(i)];
%             %使用2013/12/10减去故障时刻作为故障时间
%             if isa(raw_t{ind_fc(j),col_ct_f},'cell')
%                 obj=flipud(raw_t{ind_fc(j),col_ct_f});  %倒着排
%                 if i==1
%                     mttf=datenum(obj(i))-...
%                         datenum(raw_t{ind_fc(j),col_udt_f});
%                 else
%                     mttf=datenum(obj(i))-...
%                         datenum(obj(i-1));
%                 end
%             elseif isa(raw_t{ind_fc(j),col_ct_f},'char')
%                 mttf=datenum(raw_t{ind_fc(j),col_ct_f})-...
%                         datenum(raw_t{ind_fc(j),col_udt_f});
%                 
%             end
%             data_regfail{i,1}=[data_regfail{i,1};mttf];
        end
    end
    ret=data_regfail;
    toc;
end