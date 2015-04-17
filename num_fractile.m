%求分位点
%输入,一列数,和要求的分位值(1-100)
%输出,分位点 如输入[1,3,7,5]和50.输出4,没有第2.5个数,所以用第2,第3的平均做为分位值
function value=num_fractile(array,m)
    ary1=sort(array);
    len_a=length(ary1);
    range=len_a/100;  
    sn=range*m+0.5;
    if sn ~= round(sn)
        value=(ary1(ceil(sn))+ary1(floor(sn)))/2
    else
        value=ary1(sn);
    end
end