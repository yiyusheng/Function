%����ip��̱�Ļ��͸���ҵ��,�ϼ�ʱ�������.������������,�������򲻸�.
%��һ��col��Ӧsvr_info��Ӧ��ori�е���,�ڶ���col��ӦҪ��ȡ��Ϣ����
%�����ret�Ƕ�Ӧ�ֶε�ֵ,ia��svr_info�е�����,ib��ori�еĶ�Ӧ����
function [ret ia ib]=info_search(svr_info,ori,col_search,col_need)
    [ia ib]=ismember(svr_info,ori(:,col_search));   %ia��Ӧ����ǰһ���Ƿ��ں�һ���д���.ib��Ӧ���Ǻ�һ������ǰһ����ڵ�����.��������Ϊ0
end