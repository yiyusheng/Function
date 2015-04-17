%���㼯���л�����ÿ�¹�����,���ϼܵ�һ���¿�ʼ
%ֻ��һ��,���ֹ��ϴ���.����Ϊĳ�·������ϵĹ��ϴ���,��ĸΪĳ�����ϼܵĻ�������Ӧ��Ӳ����
function retset=mon_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    from=datevec('2013/11/01');
    disp('mon_frate processing......');
    col_ft_f=find_col('fail_time',itm_f);      %���ϻ����Ĺ���ʱ����
    col_ut_f=find_col('used_time',itm_f);      %���ϻ��ѷ���ʱ��
    col_ut_a=find_col('used_time',itm_a);      %���л����ѷ���ʱ��
    col_fc_f=find_col('fail_count',itm_f);      %���ϻ��������ϴ���
    col_ct_f=find_col('create_time',itm_f);     %���ϻ����Ϸ���ʱ��
    col_dc_a=find_col('dev_class_name',itm_a);  %������������Ӳ����
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end

    %��ȡ��i�ι��ϵĹ��Ͼ�������
    fail_count_t=cell2mat(raw_t(:,col_fc_f));
    data_regfail=cell(fc+1,1);     %ǰf_count�ŵ�ÿһ�ι��ϵ�����,����һ�ηŵ��ܵ�
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %����Ҫע��
        %ʹ��2013/11/01��ȥ����ʱ����Ϊ����ʱ��
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
    %��ȡ���л����Ĺ���ʱ������
    failtime_ct=datevec(raw_f(:,col_ct_f));
    o=ones(size(failtime_ct,1),1);
    failtime_fc=(from(1)*o-failtime_ct(:,1))*12+(from(2)*o-failtime_ct(:,2))+...
            ceil((from(3)*o-failtime_ct(:,3))/31);
    data_regfail{end,1}=[failtime_fc,...
        cell2mat(raw_f(:,col_ut_f))];   %�ڱ������еڶ���û������ 
    regtime_a=cell2mat(raw_a(:,col_ut_a));  
    max_regtime=max(regtime_a);     %�����С�ķ���ʱ��
    min_regtime=min(regtime_a);
    
    
    retset=cell(size(data_regfail,1),3);
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);  %����ʱ�ľ���ʱ��=1101-����ʱ��
        regtime_f=data_regfail{i,1}(:,2);   %�ϼ�ʱ��
        max_failtime=max(failtime_f);   %�������С�Ĺ���ʱ��
        min_failtime=min(failtime_f);
        ret_numer=zeros((max_regtime-min_regtime+1),1);   %����
        ret_denomi=zeros((max_regtime-min_regtime+1),1);   %��ĸ
        %��ĸ,�����ϼ�ʱ���С��¼,ֻ��һ��
        for j=max_regtime:-1:min_regtime
            ind_denomi=find(regtime_a>=j);%���ں�Ҫȡ��
            ret_denomi(max_regtime-j+1,1)=...
                sum(num_hd(raw_a(ind_denomi,col_dc_a),num_dc));
        end
        %�������
        %��:���ϼܵ�һ���µĹ����ʿ�ʼ����.
        for j=max_regtime:-1:min_regtime
            ind_f=find(failtime_f==j);  %����ʱ��Ϊj�Ĺ��ϵ�
            ret_numer(max_regtime-j+1,1)=length(ind_f);
        end
        ret=ret_numer./ret_denomi; 
        ret=[(min_regtime:max_regtime)',ret];  %��һ�б�ʾÿ��Ϊ����ʱ��
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    
    toc;
end