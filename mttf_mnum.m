%�����޹���ʱ�������̨���Ĺ�ϵ
%�������е�,ֻ�����i�ι���ǰ�޹���ʱ��
function ret=mttf_mnum(raw_f,raw_t,raw_a,num_dc,itm_f,itm_a,f_count)
    tic;
    disp('mttf_mnum processing......');
%     from=datevec('2013/11/01');
%     col_ft_f=find_col('fail_time',itm_f);      %���ϻ����Ĺ���ʱ����
%     col_ut_f=find_col('used_time',itm_f);      %���ϻ��ѷ���ʱ��
%     col_ut_a=find_col('used_time',itm_a);      %���л����ѷ���ʱ��
%     col_udt_f=find_col('use_time',itm_f);       %���ϻ��ϼ�ʱ��
    col_fc_f=find_col('fail_count',itm_f);      %���ϻ��������ϴ���
%     col_ct_f=find_col('create_time',itm_f);     %���Ϸ����ľ���ʱ��
%     col_svrid_f=find_col('svr_asset_id',itm_f); %���ϻ���ʶ
    col_af_f=find_col('among_fail_time',itm_f); %�޹���ʱ����
    if f_count==-1
        fc=1;
    else
        fc=f_count;
    end
    
    %��ȡ����ʱ��
    fail_count_t=cell2mat(raw_t(:,col_fc_f));   %����ÿ̨�����Ĺ��ϴ���
    data_regfail=cell(fc,1);     
    %�洢ǰn�ι���ǰ���޹���ʱ��
    for i=1:fc
        ind_fc=find(fail_count_t>=i);   %ֻ�й��ϴ�������i�Ļ������е�i�ι��ϵ�ʱ��
        for j=1:length(ind_fc)
            data_regfail{i,1}=[data_regfail{i,1};raw_t{ind_fc(j),col_af_f}(i)];
%             %ʹ��2013/12/10��ȥ����ʱ����Ϊ����ʱ��
%             if isa(raw_t{ind_fc(j),col_ct_f},'cell')
%                 obj=flipud(raw_t{ind_fc(j),col_ct_f});  %������
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