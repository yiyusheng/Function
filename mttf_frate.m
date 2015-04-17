%�������ʱ��������ʵĹ�ϵ,ʵ���϶��ڵ�һ�ι�����˵���޹���ʱ��,�����޹���ʱ��ķ���.
%���Ƕ��ڵڶ��ι�����˵,�ⲻ�������޹���ʱ����.��Ϊ�ڶ��ι��ϵ��޹���ʱ��Ӧ���Ƕ��ι���ʱ�̼�һ�ι���ʱ��
%���Ի�������ʱ����׼ȷ��,ֻ����mttf���term.
%����ʱ����ʱ���������֮ǰ���������raw_f�еĹ���ʱ��fail_time
function [retall retset]=mttf_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('mttf_frate processing......');
    col_ft_f=find_col('fail_time',itm_f);      %���ϻ����Ĺ���ʱ����
    col_ut_f=find_col('used_time',itm_f);      %���ϻ��ѷ���ʱ��
    col_ut_a=find_col('used_time',itm_a);      %���л����ѷ���ʱ��
    col_fc_f=find_col('fail_count',itm_f);      %���ϻ��������ϴ���
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end

    %��ȡ��i�ι��ϵĹ���ʱ������
    fail_count_t=cell2mat(raw_t(:,col_fc_f));
    data_regfail=cell(fc+1,1);     %ǰf_count�ŵ�ÿһ�ι��ϵ�����,����һ�ηŵ��ܵ�
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %����Ҫע��
        for j=1:length(ind_fc)
            failtime_fc=raw_t{ind_fc(j),col_ft_f}(i);   %��i�ι��ϵĹ���ʱ��
            regtime_fc=raw_t{ind_fc(j),col_ut_f};       %��Ӧ�ķ���ʱ��
            data_regfail{i,1}=[data_regfail{i,1};
                failtime_fc,regtime_fc];
        end
    end
    %��ȡ���л����Ĺ���ʱ������
    data_regfail{end,1}=[cell2mat(raw_f(:,col_ft_f)),...
        cell2mat(raw_f(:,col_ut_f))];   %�ڱ������еڶ���û������ 
    regtime_a=cell2mat(raw_a(:,col_ut_a));  
    max_regtime=max(regtime_a);     %�����С�ķ���ʱ��
    min_regtime=min(regtime_a);
    
    
    retset=cell(size(data_regfail,1),3);
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);  %����ʱ���ѷ���ʱ��,���������
        regtime_f=data_regfail{i,1}(:,2);   %�ϼ�ʱ��
        max_failtime=max(failtime_f);   %�������С�Ĺ���ʱ��
        min_failtime=min(failtime_f);
        ret_numer=zeros((max_failtime-min_failtime+1),1);   %����
        ret_denomi=zeros((max_failtime-min_failtime+1),1);   %��ĸ
        %��ĸ,���ݹ���ʱ���С��¼,ֻ��һ��
        for j=min_failtime:max_failtime
            ret_denomi(j-min_failtime+1,1)=length(find(regtime_a>=j));  %���ں�Ҫȡ��
        end
        %�������
        %��:���ϼܵ�һ���µĹ����ʿ�ʼ����.
        %��Ϊ��������ǹ���ʱ�ķ���ʱ��.�����Ǵ���С�Ĺ���ʱ�俪ʼ��
        for j=min_failtime:max_failtime
            ind_f=find(failtime_f==j);  %����ʱ��Ϊj�Ĺ��ϵ�
            ret_numer(j-min_failtime+1,1)=length(ind_f);
        end
        ret=ret_numer./ret_denomi; 
        ret=[(min_failtime:max_failtime)',ret];  %��һ�б�ʾÿ��Ϊ����ʱ��
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    retall=retset{end,1};
    toc;
end