 %���������Ļ��ͼ���Ӳ�̵�����,�����Ϊ{A1;A3;TS3;TS3]���ص���Щ�������ֱ��ж���Ӳ��
 %countΪÿ�����͹��ж���Ӳ��,uni_dcΪ���ͺ�
 function [count uni_dc]=num_hd(dc,num_dc)
 uni_dc=unique(dc);
 len_dc=length(uni_dc);
 count=zeros(len_dc,1);
 for i=1:len_dc
     ind_nbs=find(strcmp(uni_dc{i},dc(:,1)));       %find index in dc
     per=0;
     ind_per=find(strcmp(num_dc(:,1),uni_dc{i}));   
     if ~isempty(ind_per)
         per=num_dc{ind_per,2}+num_dc{ind_per,3};   %find count of hd of the dc
     else
%          uni_dc{i}
     end
     count(i)=length(ind_nbs)*per;          %count of some dc
 end