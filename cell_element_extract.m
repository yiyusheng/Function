%ȡһ��cell�е�ÿ��cell���еĵ�һ��Ԫ��
function c=cell_element_extract(array,rank)
   [m n]=size(array);
   c=array;
   for i=1:m
       for j=1:n
           if isa(array{i,j},'cell')
                r1=size(array{i,j},1);
                c{i,j}=array{i,j}{min(rank,r1),1};  %ȡ��rank��,�����һ��
           end
       end
   end
end