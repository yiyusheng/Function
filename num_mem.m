%求一列机型的内存容量
function [count uni_dc]=num_mem(dc,mem_dc)
     uni_dc=unique(dc);
     len_dc=length(uni_dc);
     count=zeros(len_dc,1);
     for i=1:len_dc
         ind_nbs=find(strcmp(uni_dc{i},dc(:,1)));       %find index in dc
         per=0;
         ind_per=find(strcmp(mem_dc(:,1),uni_dc{i}));   
         if ~isempty(ind_per)
             per=mem_dc{ind_per,2};   %find count of hd of the dc
         end
         count(i)=length(ind_nbs)*per;          %count of some dc
     end
end

