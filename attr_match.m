%输入ip或固资,输入要匹配的文件,输入要匹配的列,给出匹配的行和匹配的结果
function [m ind]=attr_match(ori,tar,col_ori,col_tar,col_attr)
    [ind ia]=ismember(ori(:,col_ori),tar(:,col_tar));
    m=cell(size(ori,1),length(col_attr));
    m(find(ind==1),:)=tar(ia(find(ia~=0)),col_attr);
end