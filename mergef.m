%把raw_f故障单合并成机器故障单
%输入:故障单,主要列(根据这一列中无重复的元素,合并),合并列
%col_m1是这些列的被结合的元素长度相同的,col_m2是元素长度不同的
%mergef(raw_f,2,[8,9,10],[1,4])
function raw_time=mergef(raw_f,col,col_m1,col_m2)
    [m n]=size(raw_f);
    len_m1=length(col_m1);
    len_m2=length(col_m2);
    if max(col,max(max(col_m1),max(col_m2)))>n
        raw_time='wrong';           %如果输入的列大于最大列数,则报错
    end

    col_=zeros(1,n);
    col_(1,[col_m1,col_m2])=1;    %需要做重叠的列
    col_one=find(col_==0);  %不需要做重叠的列

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
        raw_time(i,col_one)=raw_f(ind(1),col_one);    %无需合并的信息赋值,取多行中的第一行,把这一行的数据赋值给raw_time
        for j=1:len_m1
            tmp=raw_f(ind,col_m1(j));
            raw_time{i,col_m1(j)}=cell2mat(tmp);     %长度相同
           
        end
        for j=1:len_m2
            tmp=raw_f(ind,col_m2(j));
            raw_time{i,col_m2(j)}=tmp;           %长度不同
        end
         
    end
    close(h);
end