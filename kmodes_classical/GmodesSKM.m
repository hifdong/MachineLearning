function [modes, counts] = GmodesSKM(X, index, clusts)  
 %matlab version:7.13.0.564
%����˵�����������ļ��㺯��
%Input: 'X' -dataset ,'index' - class index ,'clusts' - cluster number .
%Output: 'modes' -class modes, 'counts' -number of object in each class.
%GCENTROIDS Centroids and counts stratified by group.
[n, p] = size(X);
num = length(clusts);   %length=MAX(SIZE(X))
modes = NaN(num, p);
counts = zeros(num,1);   

%�ҳ�ÿһ�������ÿ������Ƶ����ߵ���Ϊmodes
for i = 1:num  
    members = (index == clusts(i));
    if any(members)
        counts(i) = sum(members);
        %��������ڸ����Ե�Ƶ��
        [f, v] = Fraq(X(members, :)); 
        %����ģʽ������
        for j = 1:p
            %��Զ��������� ��������Ԫ��Ƶ��С���µģ������
          [val, inx_max] = max(f{j, 1});
           if (modes(i, j) ~= v{j, 1}(1, inx_max))
                modes(i, j) = v{j, 1}(1, inx_max);  
           end
        end
    end
end

end