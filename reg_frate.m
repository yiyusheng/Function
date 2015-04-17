%���ϼ�ʱ��������ʵĹ�ϵ.
%�����ϼ�ʱ��(�ѷ���ʱ��)�����й��ϻ�����,���ÿ�����ϼܵĻ��������ϼ�֮��ÿ���µĹ�����.
%����:���ϵ�,���ϻ�,�ܻ�,Ӳ��ͳ��,���ϵ�Ŀ¼,�ܻ�Ŀ¼,���㼸�ι���
%���:retall�����й��ϵ��ϼ�ʱ��������ʹ�ϵ,ÿһ�е�һ��Ԫ�ش�����һ�б�ʾ���ǵ�i����ǰ�ϼܵĻ���
%retset�Ƿֵ�i�ι��ϵ�,���ϵ����ǵ�i�ι��ϵ�����.���һ�������й��ϵ�.
function [retall retset]=reg_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('reg_frate processing......');
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
        ind_fc=find(fail_count_t>=i);   %��Ϊ���ڵ���i���е�i�ι���.����ȡ����i��Ԫ��
        for j=1:length(ind_fc)
            failtime_fc=raw_t{ind_fc(j),col_ft_f}(i);
            regtime_fc=raw_t{ind_fc(j),col_ut_f};
            data_regfail{i,1}=[data_regfail{i,1};
                failtime_fc,regtime_fc];
        end
    end
    %��ȡ���л����Ĺ���ʱ������
    data_regfail{end,1}=[cell2mat(raw_f(:,col_ft_f)),...
        cell2mat(raw_f(:,col_ut_f))];
    regtime_a=cell2mat(raw_a(:,col_ut_a));  
    max_regtime=max(regtime_a);
    min_regtime=min(regtime_a);
    max_failtime=max(data_regfail{end,1}(:,1));
    min_failtime=min(data_regfail{end,1}(:,1));
    
    retset=cell(size(data_regfail,1),3);
    %�����ϼ�ʱ��Թ��ϻ����з���
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);
        regtime_f=data_regfail{i,1}(:,2);
        len_r=max_regtime-min_regtime+1;    %����
        len_c=max_failtime-min_failtime+1; 
        ret_numer=zeros(len_r,max_regtime+1);   %����
        ret_denomi=zeros(len_r,max_regtime+1);   %��ĸ
        %��:�����ϼ�ʱ��,��ǰ����
        for j=max_regtime:-1:min_regtime
            ind_a=find(regtime_a==j);   %����ʱ��Ϊi�Ļ���
            ind_f=find(regtime_f==j);   %����ʱ��Ϊi�Ĺ��ϵ�
            ret_denomi(max_regtime-j+1,:)=length(ind_a);    %��ĸ,һ��ȫΪͬһ��ֵ,�ӵ�һ�п�ʼ
            %����ʱ��С��j�Ļ���,����ʱ��Ҳ��С��j,���ж�Ϊ��1��ʼ��˳��ľ���ʱ��,
            %��Ϊ����ʱ��Ϊj�Ļ���,����ʱ��С�ڵ���j,����ֻҪѭ����j
            for k=0:j
                ind_ft_f=find(failtime_f(ind_f)==k);     %����ʱ��Ϊi�Ĺ��ϵ���,����ʱ��Ϊj�ĵ�������
                %һ��ǰ��Ӧ����max_regtime-j��0,��k��0��ʼ,����Ҫ+1
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