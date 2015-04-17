%计算cell中元素有多少行
%col为同一机器的多元素集中列,col_f为故障次数行
function ret=fail_count(raw_t,col)
    ret=zeros(length(raw_t),1);
    for i=1:length(raw_t)
        ret(i)=size(raw_t{i,col},1);
    end
end