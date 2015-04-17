%���ݹ���ʱ�����,ÿһ�д���һ���µĹ���,����·������ϻ����ϼ�ʱ��ķֲ�.
function [retall retset]=fail_frate(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('fail_frate processing......');
    from=datevec('2013/11/01');
    col_ft_f=find_col('fail_time',itm_f);      %���ϻ����Ĺ���ʱ����
    col_ut_f=find_col('used_time',itm_f);      %���ϻ��ѷ���ʱ��
    col_ut_a=find_col('used_time',itm_a);      %���л����ѷ���ʱ��
    col_fc_f=find_col('fail_count',itm_f);      %���ϻ��������ϴ���
    col_ct_f=find_col('create_time',itm_f);     %���Ϸ����ľ���ʱ��
    col_svrid_f=find_col('svr_asset_id',itm_f); %���ϻ���ʶ
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end
    
    %��ȡ��i�ι��ϵľ���ʱ��,��2013/11/01-����ʱ��
    fail_count_t=cell2mat(raw_t(:,col_fc_f));   %����ÿ̨�����Ĺ��ϴ���
    data_regfail=cell(fc+2,1);     
    %ǰf_count�ŵ�ÿһ�ι��ϵ�����,����һ�ηŵ��ܵ�(���Ƿ��ͬһ̨������ͬһ���µĹ��Ϻϲ�)
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %ֻ�й��ϴ�������i�Ļ������е�i�ι��ϵ�ʱ��
        for j=1:length(ind_fc)
            %ʹ��2013/12/10��ȥ����ʱ����Ϊ����ʱ��
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
    %��ȡ���й��ϻ����Ĺ���ʱ������
    failtime_ct=datevec(raw_f(:,col_ct_f));
    o=ones(size(failtime_ct,1),1);
    failtime_fc=(from(1)*o-failtime_ct(:,1))*12+...
        (from(2)*o-failtime_ct(:,2))+...
        ceil((from(3)*o-failtime_ct(:,3))/30);
    data_regfail{end-1,1}=[failtime_fc,cell2mat(raw_f(:,col_ut_f))];
    data_regfail{end,1}=[failtime_fc,cell2mat(raw_f(:,col_ut_f))]; 
    %���л������ϼ�ʱ��
    regtime_a=cell2mat(raw_a(:,col_ut_a));
    %���������С�ϼ�ʱ��
    max_regtime=max(regtime_a);
    min_regtime=min(regtime_a);
    %��Ϊÿһ�еķ�ĸ��һ����,�ȼ������
    row_denomi=zeros(1,max_regtime-min_regtime+1);
    %��:�ϼ�ʱ���45��ǰ��ʼ,��1����ǰ
    for i=max_regtime:-1:min_regtime
        ind_a=find(regtime_a==i);
        row_denomi(1,max_regtime-i+1)=length(ind_a);
    end
    
    %���ݹ���ʱ�̶Թ��ϻ����з���.
    retset=cell(size(data_regfail,1),3);
    for i=1:size(data_regfail,1)
        failtime_f=data_regfail{i,1}(:,1);  %����Ѿ��ǹ���ʱ��,��Ϊ����ʱ��
        regtime_f=data_regfail{i,1}(:,2);   %�ϼ�ʱ��
        max_failtime=max(failtime_f);   %�������С�Ĺ���ʱ��
        min_failtime=min(failtime_f);
        ret_numer=zeros((max_failtime-min_failtime+1),max_regtime-min_regtime+1);   %����
        ret_denomi=zeros((max_failtime-min_failtime+1),max_regtime-min_regtime+1);   %��ĸ
        %װ���ĸ
        for j=1:size(ret_denomi,1)
            ret_denomi(j,:)=row_denomi;
        end
        %�������
        %��:��45����ǰ�Ĺ��Ͽ�ʼ.
        for j=max_failtime:-1:min_failtime
            ind_f=find(failtime_f==j);  %����ʱ��Ϊj�Ĺ��ϵ�
            %�������е�,ͬһ���·�����ι��ϵĻ���,ֻ��Ϊ������һ�ι���.����������
            if i==size(data_regfail,1)
                uni_svrid=unique(raw_f(ind_f,col_svrid_f));
                [~,~,ind_f1]=intersect(uni_svrid,raw_f(ind_f,col_svrid_f));
                ind_f=ind_f(ind_f1);
            end
            %��:��45��ǰ��ʼ    
            for k=max_regtime:-1:min_regtime
                fail_reg_f=regtime_f(ind_f);    %ĳ�·����Ĺ��϶�Ӧ���ϼ�ʱ��
                ret_numer(max_failtime-j+1,max_regtime-k+1)=length(find(fail_reg_f==k));
            end
        end
%         for j=min_failtime:max_failtime
%             ind_f=find(failtime_f==j);  %����ʱ��Ϊj�Ĺ��ϵ�
%             %�������е�,ͬһ���·�����ι��ϵĻ���,ֻ��Ϊ������һ�ι���.����������
%             if i==size(data_regfail,1)
%                 uni_svrid=unique(raw_f(ind_f,col_svrid_f));
%                 [~,~,ind_f1]=intersect(uni_svrid,raw_f(ind_f,col_svrid_f));
%                 ind_f=ind_f(ind_f1);
%             end
%             %��:��45��ǰ��ʼ    
%             for k=max_regtime:-1:min_regtime
%                 fail_reg_f=regtime_f(ind_f);    %ĳ�·����Ĺ��϶�Ӧ���ϼ�ʱ��
%                 ret_numer(j-min_failtime+1,max_regtime-k+1)=length(find(fail_reg_f==k));
%             end
%         end
        ret=ret_numer./ret_denomi; 
        ret=[min_regtime:max_regtime;ret];  %��һ�б�ʾÿ��Ϊ�ϼ�ʱ��ķֲ�
        ret=[[-1,min_failtime:max_failtime]',ret];
        retset{i,1}=ret;
        retset{i,2}=ret_numer;
        retset{i,3}=ret_denomi;
    end
    retall=retset{end,1};
    toc;
end