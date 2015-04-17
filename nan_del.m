%��nan���о�ɾ��
%����,��Ҫȥnan�ľ������(һ����ֻҪ��һ��nan,��һ�оͱ�ȥ����)
%���,ȥ��֮��ľ������,�Լ�ȥ��������(Ϊ1��Ҫȥ)
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