%����ͳ����������
%col��col_a���������з�����ֶ�,�����н���Ǹ����������ֶν��з����
%���綼ѡ��ҵ����,�ó����Ǹ�ҵ��ĸ���Ϣ,ѡ��������ǵó������͵ĸ���Ϣ
%����������һ������ǲ���� �Ǹ����ľ���ĳ��������ͻ�ҵ�����Ϣ.�����Ұѷ�C1�Ļ��͹���,���ù��˺��������Ϊ����
%�ó��ľ���C1�ĸ�����Ϣ.��Ȼ,�������������Ҫѡ������,���ѡҵ������ô�ó��ľ���C1���͵ĸ�ҵ�������
%��������Ϊ-1 ��ô�ͷ������е�

%����:
%���ϵ�(����Ϊ����,ÿ̨�������й���Ϊһ��),���ϵ�(ÿ�ι���Ϊһ��),���ϵ���������,�ܵ�,�ܵ�������,���;�������ļ�,���������ܵ����ֶ���,���ϵ����ֶ���
%���(ÿһ��һ��):
%���ϴ���,����̨��,����̨��,Ӳ����̨��,���ϻ�ƽ������ʱ��,��̨��ƽ������ʱ��,���ϴ���ռӲ����̨����,����̨��ռ����̨����
%������1,������2,����̨ռ��,ƽ�����ϴ���
%ǰ��ι���ʱ��Ĺ���̨��,ǰi���µĹ��ϴ���,������(Ӳ��),������(̨��),�ۻ�������(ǰi���µĹ�����)
function [ret ret_raw itm]=proc_fail(raw_t,raw_f,col,raw_a,col_a,num_dc,itm_a,itm_f)
tic;
ret=1;
col_num_f=find_col('fail_count',itm_f);     %���ϵ��й��ϴ���������
col_time_f=find_col('fail_time',itm_f);      %����ʱ���ѷ���ʱ��
col_time_a=find_col('used_time',itm_a);      %�ܵ����ѷ���ʱ��
col_dc_a=find_col('dev_class_name',itm_a);     %�ܵ���
enable_fu=1; %Ϊ1�����ǰi�ι��ϵ�̨������,�����ʵ�
f_count=ones(5,1)*2;      %��¼���ϴ���

%��Ϊ-1�Ĵ���ʽ
flag_col=0;
if col==-1 || col_a==-1
    flag_col=-1;
    raw_t=cat(2,raw_t,cellstr(num2str(zeros(size(raw_t,1),1))));
    raw_f=cat(2,raw_f,cellstr(num2str(zeros(size(raw_f,1),1))));
    raw_a=cat(2,raw_a,cellstr(num2str(zeros(size(raw_a,1),1))));
    col=size(raw_t,2);
    col_a=size(raw_a,2);
end

%�������͵Ĵ���->ת��Ϊ�ַ�(��ΪuniqueҪ����cellstr��������)
if isa(raw_t{1,col},'double')
    if isa(cell2mat(raw_t(:,col)),'double')
        raw_t(:,col)=cellstr(num2str(cell2mat(raw_t(:,col))));
    end
    if isa(cell2mat(raw_f(:,col)),'double')
        raw_f(:,col)=cellstr(num2str(cell2mat(raw_f(:,col))));
    end
    if isa(cell2mat(raw_a(:,col_a)),'double')
        raw_a(:,col_a)=cellstr(num2str(cell2mat(raw_a(:,col_a))));
    end
end

uni=unique(raw_t(:,col));
uni=uni([1:end],:);
ind_noneed=find(strcmp(uni,'###')==1);
if ~isempty(ind_noneed) && length(uni)==1
    return ;
end
uni(ind_noneed,:)=[];   %ȥ��###����
len=length(uni);
len_a=length(raw_a);
ret=cell(len,10);
h=waitbar(0,'function-procfail');
last=11;
%һ��һ��Ĵ���
for i=1:len
    waitbar(i/len,h,strcat('function-procfail: ',uni{i}));
    ind1=find(strcmp(uni{i},raw_t(:,col)));     %ĳ�����̨��
    ind2=find(strcmp(uni{i},raw_a(:,col_a)));   %ĳ�����̨��
    ind3=find(strcmp(uni{i},raw_f(:,col)));     %ĳ����ϵ���
    if isempty(ind1)||isempty(ind2)|| isempty(ind3)
        continue;
    end
    ret{i,1}=length(ind3);      %���ϴ���
    ret{i,2}=length(ind1);          %����̨��
    ret{i,3}=length(ind2);          %����̨��
    ret{i,4}=sum(num_hd(raw_a(ind2,col_dc_a),num_dc));  %Ӳ����̨��
    
    a=raw_t(ind1,:);
    b=raw_a(ind2,:);
    c=raw_f(ind3,:);
    ret{i,10}=mean(cell2mat(raw_t(ind1,col_time_f)));         %���ϻ�ƽ������ʱ��,���ʱ��Ӧ���ǹ���ʱ���ѷ���ʱ��
    ret{i,11}=mean(cell2mat(raw_a(ind2,col_time_a)));      %�ܻ�ƽ������ʱ��
    if enable_fu==1
         [ne ret{i,last+1}]=...
             reg_frate(c,a,b,num_dc,itm_f,itm_a,f_count(1));
         
          [ne ret{i,last+2}]=...
             fail_frate(c,a,b,num_dc,itm_f,itm_a,f_count(2));
         
          [ret{i,last+3}]=...
             mttf_mnum(c,a,b,num_dc,itm_f,itm_a,f_count(3));
         
          [ne ret{i,last+4}]=...
             mttf_frate(c,a,b,num_dc,itm_f,itm_a,f_count(4));
         
         ret{i,last+5}=fnum(c,a,b,num_dc,itm_f,itm_a);
         
		  [ret{i,last+6}]=...
             mon_frate(c,a,b,num_dc,itm_f,itm_a,f_count(5));
    end
%     if enable_fu==1
%         [out1a out1b]=ftime(a,b,f_count,num_dc,itm_f,itm_a);
%          ret{i,last+1}=out1b{1};
%          ret{i,last+2}=out1b{2};
%          ret{i,last+3}=out1b{3};
%          ret{i,last+4}=out1b{4};
%          ret{i,last+5}=out1b{5};
%         [out1c ret{i,last+6}]=utime(c,b,num_dc,itm_f,itm_a);
%     end


    
end
ret(:,5)=num2cell(cell2mat(ret(:,1))./cell2mat(ret(:,4)));    %������1
ret(:,6)=num2cell(cell2mat(ret(:,2))./cell2mat(ret(:,4)));    %������2
ret(:,7)=num2cell(cell2mat(ret(:,2))./cell2mat(ret(:,3)));    %����̨ռ��
ret(:,8)=num2cell(cell2mat(ret(:,1))./cell2mat(ret(:,2)));    %ƽ�����ϴ���
up=cell2mat(ret(:,8));down=cell2mat(ret(:,7));
% up=up/sum(up);down=down/sum(down);
ret(:,9)=num2cell(up./down);    %�����ܶ�


ret=cat(2,uni,ret);
if flag_col~=-1
    tp=itm_a(1,col_a);
else
    tp='all';
end
if enable_fu==1
    itm=[{tp},{'���ϴ���'},{'����̨��'},{'����̨��'},{'Ӳ������'},{'������(���ϴ���/Ӳ������)'},...
        {'������(����̨��/Ӳ������)'},...
        {'ռ��(����̨��/����̨��)'},{'ƽ�����ϴ���(���ϴ���/����̨��)'},{'�����ܶ�(ռ��/ƽ�����ϴ���)'},...
        {'���ϻ�ƽ������ʱ��'},{'�ܻ�ƽ������ʱ��'},...
        {'�ϼ�ʱ��-������'},{'����ʱ��-�ϼ�ʱ��ֲ�'},{'�޹���ʱ��-����̨��'},...
        {'����ʱ��-������'},{'���ϴ���-����̨��'},{'ÿ�¹�����'}];
else
    itm=[{tp},{'���ϴ���'},{'����̨��'},{'����̨��'},{'Ӳ������'},{'������(���ϴ���/Ӳ������)'},...
        {'������(����̨��/Ӳ������)'},...
        {'ռ��(����̨��/����̨��)'},{'ƽ�����ϴ���(���ϴ���/����̨��)'},{'�����ܶ�(ռ��/ƽ�����ϴ���)'},...
        {'���ϻ�ƽ������ʱ��'},{'�ܻ�ƽ������ʱ��'}];
end
% if enable_fu==1
%     itm=[{tp},{'���ϴ���'},{'����̨��'},{'����̨��'},{'Ӳ������'},{'������(���ϴ���/Ӳ������)'},...
%         {'������(����̨��/Ӳ������)'},...
%         {'ռ��(����̨��/����̨��)'},{'ƽ�����ϴ���(���ϴ���/����̨��)'},{'�����ܶ�(ռ��/ƽ�����ϴ���)'},...
%         {'���ϻ�ƽ������ʱ��'},{'�ܻ�ƽ������ʱ��'},...
%         {'����ʱ��-����̨��'},{'����ʱ��-����̨��[ǰn����]'},{'����ʱ��-������(Ӳ��)'},...
%         {'����ʱ��-������(̨��)'},{'����ʱ��-������(Ӳ��)[ǰn����]'},{'�ϼ�ʱ��-��Ϣ'}];
% else
%     itm=[{tp},{'���ϴ���'},{'����̨��'},{'����̨��'},{'Ӳ������'},{'������(���ϴ���/Ӳ������)'},...
%         {'������(����̨��/Ӳ������)'},...
%         {'ռ��(����̨��/����̨��)'},{'ƽ�����ϴ���(���ϴ���/����̨��)'},{'�����ܶ�(ռ��/ƽ�����ϴ���)'},...
%         {'���ϻ�ƽ������ʱ��'},{'�ܻ�ƽ������ʱ��'}];
% end
ret_raw=ret;
ret=cat(1,itm,ret);
toc;
close(h);