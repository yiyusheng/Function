%%�����ϼ�ʱ������ϵĹ�ϵ
%����Ϊ���ϵ����ܵ�
%usinfoΪ���ϵ����ܵ��и����ϼ�ʱ����Ĺ��ϴ���,����̨��,����̨��,Ӳ����̨��,
%���ϴ���ռ��,����̨��ռ��,
%������1,������2,ƽ�����ϴ���
function [ret ret1]=utime(raw_f,raw_a,num_dc,itm_f,itm_a)
    col_us_f=find_col('used_time',itm_f);     %�ѷ���ʱ��
    col_svrid_f=find_col('svr_asset_id',itm_f);   %���ϵ��й��ʺ���
    col_us_a=find_col('used_time',itm_a);     %�ѷ���ʱ��
    col_dc_a=find_col('dev_class_name',itm_a);     %�ܵ��л��͵���
    us_f=cell2mat(raw_f(:,col_us_f));
    us_a=cell2mat(raw_a(:,col_us_a));
    min_a=min(us_a);
    max_a=max(us_a);
    len=max_a-min_a+1;
    ret=zeros(len,9);
%     h=waitbar(0,'utime');
    for ii=min_a:max_a
        i=ii-min_a+1;   %��1��ʼ������
%         waitbar(i/len,h,strcat('utime:',num2str(i)));
        ind_f=find(us_f==ii);        %��Ӧʱ��Ĺ��ϵ�����
        ind_a=find(us_a==ii);        %��Ӧʱ����ܵ�����
        ret(i,1)=length(ind_f);     %���ϴ���
        if size(ind_f,1)==0
            ret(i,2)=0;
        else
            ret(i,2)=length(unique(raw_f(ind_f(:,1),col_svrid_f)));   %ͨ�����ʺ���ȷ������̨��
        end
        ret(i,3)=length(ind_a);     %�ܵ�����̨��
        ret(i,4)=sum(num_hd(raw_a(ind_a,col_dc_a),num_dc));
    end
    ret(:,5)=ret(:,1)./sum(ret(:,1));
    ret(:,6)=ret(:,2)./sum(ret(:,2));
    ret(:,7)=ret(:,1)./ret(:,4);
    ret(:,8)=ret(:,2)./ret(:,4);
    ret(:,9)=ret(:,1)./ret(:,2);
    ret(find(isnan(ret(:,7))),7)=-1;
    ret(find(isnan(ret(:,8))),8)=-1;
    ret(find(isnan(ret(:,9))),9)=-1;
    ret=[(min_a:max_a)',ret];
    item=[{'�ϼ�ʱ��'},{'���ϴ���'},{'����̨��'},{'����̨��'},{'Ӳ������'},...
        {'���ϴ���ռ��'},{'����̨��ռ��'},{'������1'},{'������2'},{'ƽ�����ϴ���'}];
    ret1=cat(1,item,num2cell(ret));
%     close(h);
end
