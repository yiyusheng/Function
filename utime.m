%%计算上架时间与故障的关系
%输入为故障单和总单
%usinfo为故障单和总单中根据上架时间给的故障次数,故障台数,机器台数,硬盘总台数,
%故障次数占比,故障台数占比,
%故障率1,故障率2,平均故障次数
function [ret ret1]=utime(raw_f,raw_a,num_dc,itm_f,itm_a)
    col_us_f=find_col('used_time',itm_f);     %已服役时间
    col_svrid_f=find_col('svr_asset_id',itm_f);   %故障单中固资号列
    col_us_a=find_col('used_time',itm_a);     %已服役时间
    col_dc_a=find_col('dev_class_name',itm_a);     %总单中机型的列
    us_f=cell2mat(raw_f(:,col_us_f));
    us_a=cell2mat(raw_a(:,col_us_a));
    min_a=min(us_a);
    max_a=max(us_a);
    len=max_a-min_a+1;
    ret=zeros(len,9);
%     h=waitbar(0,'utime');
    for ii=min_a:max_a
        i=ii-min_a+1;   %从1开始的索引
%         waitbar(i/len,h,strcat('utime:',num2str(i)));
        ind_f=find(us_f==ii);        %对应时间的故障单索引
        ind_a=find(us_a==ii);        %对应时间的总单索引
        ret(i,1)=length(ind_f);     %故障次数
        if size(ind_f,1)==0
            ret(i,2)=0;
        else
            ret(i,2)=length(unique(raw_f(ind_f(:,1),col_svrid_f)));   %通过固资号来确定故障台数
        end
        ret(i,3)=length(ind_a);     %总单机器台数
        ret(i,4)=sum(num_hd(raw_a(ind_a,col_dc_a),num_dc));
    end
    ret(:,5)=ret(:,1)./sum(ret(:,1));
    ret(:,6)=ret(:,2)./sum(ret(:,2));
    ret(:,7)=ret(:,1)./ret(:,4);
    ret(:,8)=ret(:,2)./ret(:,4);
    ret(:,9)=ret(:,1)./ret(:,2);
    ret(find(isnan(ret(:,7))),7)=-1;
    ret(find(isnan(ret(:,8))),8)=-1;
    ret(find(isnan(ret(:,9))),9)=-1;
    ret=[(min_a:max_a)',ret];
    item=[{'上架时间'},{'故障次数'},{'故障台数'},{'机器台数'},{'硬盘总数'},...
        {'故障次数占比'},{'故障台数占比'},{'故障率1'},{'故障率2'},{'平均故障次数'}];
    ret1=cat(1,item,num2cell(ret));
%     close(h);
end
