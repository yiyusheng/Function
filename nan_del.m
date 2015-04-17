%有nan的行就删除
%输入,需要去nan的矩阵或列(一行中只要有一个nan,这一行就被去除了)
%输出,去除之后的矩阵或列,以及去除的索引(为1则要去)
function [ind ret]=nan_del(mm)
    [m n]=size(mm);
    ind=zeros(m,1);
    if isa(mm,'double')
        inds=arrayfun(@isnan,mm);
        ind=sum(inds,2);
    elseif isa(mm,'cell')
        for i=1:m
            for j=1:n
                if sum(isnan(mm{i,j}))
                    ind(i)=1;
                    continue;
                end
            end
        end
    end
    ret=mm(find(ind==0),:);
end

% ind=zeros(m,1);
% for i=1:m
%     for j=1:n
%         if iscell(mm) && sum(isnan(mm{i,j}))
%             ind(i)=1;
%         elseif isa(mm(i,j),'double') && isnan(mm(i,j))
%             ind(i)=1;
%         end
%     end
% end
% ret=mm(find(ind==0),:);