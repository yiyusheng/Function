%把cell中所有为NaN的值用指定值代替
function ret=nan_replace(mt,str)
[m n]=size(mt);
for i=1:m
    for j=1:n
        if isa(mt,'cell')&&max(isnan(mt{i,j})) 
            mt{i,j}=str;
        elseif isa(mt,'double')&&isnan(mt(i,j))
            mt(i,j)=str;
        end
    end
end
ret=mt;