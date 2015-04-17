%把cell中的只有一个cell的元素提出.比如a=cell(1,2),a{1,1}=b,b是cell,但是1*1的cell那么a{1,1}=b{1,1}
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