%���λ��
%����,һ����,��Ҫ��ķ�λֵ(1-100)
%���,��λ�� ������[1,3,7,5]��50.���4,û�е�2.5����,�����õ�2,��3��ƽ����Ϊ��λֵ
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