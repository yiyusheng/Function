%����cell��Ԫ���ж�����
%colΪͬһ�����Ķ�Ԫ�ؼ�����,col_fΪ���ϴ�����
function ret=fail_count(raw_t,col)
    ret=zeros(length(raw_t),1);
    for i=1:length(raw_t)
        ret(i)=size(raw_t{i,col},1);
    end
end