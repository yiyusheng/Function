%��raw_f���ϵ��ϲ��ɻ������ϵ�
%����:���ϵ�,��Ҫ��(������һ�������ظ���Ԫ��,�ϲ�),�ϲ���
%col_m1����Щ�еı���ϵ�Ԫ�س�����ͬ��,col_m2��Ԫ�س��Ȳ�ͬ��
%mergef(raw_f,2,[8,9,10],[1,4])
function raw_time=mergef(raw_f,col,col_m1,col_m2)
    [m n]=size(raw_f);
    len_m1=length(col_m1);
    len_m2=length(col_m2);
    if max(col,max(max(col_m1),max(col_m2)))>n
        raw_time='wrong';           %���������д����������,�򱨴�
    end

    col_=zeros(1,n);
    col_(1,[col_m1,col_m2])=1;    %��Ҫ���ص�����
    col_one=find(col_==0);  %����Ҫ���ص�����

    uni=unique(raw_f(:,col));
    len=length(uni);
    raw_time=cell(len,n);
    h=waitbar(0,'merge');
    for i=1:len
        waitbar(i/len);
        ind=find(strcmp(raw_f(:,col),uni{i}));
        if length(ind)==1
            raw_time(i,:)=raw_f(ind,:);
            continue;
        end
        raw_time(i,col_one)=raw_f(ind(1),col_one);    %����ϲ�����Ϣ��ֵ,ȡ�����еĵ�һ��,����һ�е����ݸ�ֵ��raw_time
        for j=1:len_m1
            tmp=raw_f(ind,col_m1(j));
            raw_time{i,col_m1(j)}=cell2mat(tmp);     %������ͬ
           
        end
        for j=1:len_m2
            tmp=raw_f(ind,col_m2(j));
            raw_time{i,col_m2(j)}=tmp;           %���Ȳ�ͬ
        end
         
    end
    close(h);
end