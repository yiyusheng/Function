%��cell������Ϊ�յ�cell��ָ��ֵ����
function ret=empty_replace(mt,str)
[m n]=size(mt);
for i=1:m
    for j=1:n
        if isempty(mt{i,j})
            mt{i,j}=str;
        end
    end
end
ret=mt;