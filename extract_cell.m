%��cell�е�ֻ��һ��cell��Ԫ�����.����a=cell(1,2),a{1,1}=b,b��cell,����1*1��cell��ôa{1,1}=b{1,1}
function c=extract_cell(mtr,col)
    mtr=mtr(:,col);
    [m n]=size(mtr);
    for i=1:m
        for j=1:n
            if iscell(mtr{i,j}) &&  size(mtr{i,j},1)==1 && size(mtr{i,j},2)==1
                mtr{i,j}=mtr{i,j}{1,1};
            end
        end
    end
    c=mtr;
end