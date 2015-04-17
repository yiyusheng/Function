%通过固资编号将ip补全
function ret=ip_repair(r,col_svr,col_ip)
    ori_fname='cmdb_0916.xlsx';
    col_svr_r1=2;
    col_ip_r1=3;
    [a b r1]=xlsread(ori_fname);
    [C ia ib]=intersect(r(:,col_svr),r1(:,col_svr_r1));
    len=length(ia);
    collect=[];
%     for i=1:len
%         if ~strcmp(r(ia(i),col_ip),r1(ib(i),col_ip_r1)) || strcmp(r(ia(i),col_ip),'#####')
%             i
%             collect=[collect,;];
%         end
%     end
    r(ia,col_ip)=r1(ib,col_ip_r1);
    ret=r;
end



% load('raw_fta','raw_a');