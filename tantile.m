%����һ��n��1����ֵ����,����ָ����λֵ��Ӧ������
function index=tantile(array,rate)
suma=sum(array);
len=length(array);
sum_a=suma*rate;
i=1;
while sum(array([1:i],1))<sum_a
    i=i+1;
end
index=i;
end