function rate=rate_calcu(data)
    %���㲻ͬ���͵ı���
    %����: [n 1]��������
    %���: �������в�ͬ�����ͼ�����,[m 2]����
    %����ֵֵ��vector��cell������ֵ��,�Ի���ͺ�cell����str��
%     if isa(data,'cell') && isa(data{1,1},'double') && isa(cell2mat(data),'double')
%         data=cellstr(num2str(cell2mat(data)));
%     end
    %% cell convert
    ct = cell_type(data);
    if ct == 3
        data = cell_convert(data);
    elseif ct == 1
        data = cell2mat(data);
    end
    %% rate calculate
    [m n]=size(data);
    uni_var=unique(data);
    uni_len=length(uni_var);
    rate=zeros(uni_len,2);
    if ct == 2 || ct ==3
        for i=1:uni_len
            rate(i,1)=length(find(strcmp(data(:),uni_var{i})));
            rate(i,2)=rate(i,1)/m;
        end
        rate=cat(2,uni_var,num2cell(rate));
        rate=sortrows(rate,-2);
    elseif ct == 0 || ct == 1
        for i=1:uni_len
            rate(i,1)=length(find(data(:)==uni_var(i)));
            rate(i,2)=rate(i,1)/m;
        end   
        rate=cat(2,num2cell(uni_var),num2cell(rate));
        rate=sortrows(rate,-2);
    end
    %�����ۻ�����
    accu=zeros(size(rate,1),1);
    r3=cell2mat(rate(:,3));
    accu(1)=r3(1,1);
    for i=2:size(rate,1)
        accu(i)=accu(i-1)+r3(i);
    end
    rate=cat(2,rate,num2cell(accu));
end
