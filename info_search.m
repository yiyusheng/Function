%输入ip或固编的机型给出业务,上架时间等数据.如果包含则给出,不包含则不给.
%第一个col对应svr_info对应在ori中的列,第二个col对应要提取信息的列
%输出的ret是对应字段的值,ia是svr_info中的索引,ib是ori中的对应索引
function [ret ia ib]=info_search(svr_info,ori,col_search,col_need)
    [ia ib]=ismember(svr_info,ori(:,col_search));   %ia对应的是前一项是否在后一项中存在.ib对应的是后一项中有前一项存在的索引.不存在则为0
end