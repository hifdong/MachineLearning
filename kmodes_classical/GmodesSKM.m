function [modes, counts] = GmodesSKM(X, index, clusts)  
 %matlab version:7.13.0.564
%程序说明：聚类中心计算函数
%Input: 'X' -dataset ,'index' - class index ,'clusts' - cluster number .
%Output: 'modes' -class modes, 'counts' -number of object in each class.
%GCENTROIDS Centroids and counts stratified by group.
[n, p] = size(X);
num = length(clusts);   %length=MAX(SIZE(X))
modes = NaN(num, p);
counts = zeros(num,1);   

%找出每一个类别中每个属性频率最高的作为modes
for i = 1:num  
    members = (index == clusts(i));
    if any(members)
        counts(i) = sum(members);
        %计算类别内各属性的频率
        [f, v] = Fraq(X(members, :)); 
        %设置模式的属性
        for j = 1:p
            %针对二进制数据 中心属性元素频率小于新的，则更换
          [val, inx_max] = max(f{j, 1});
           if (modes(i, j) ~= v{j, 1}(1, inx_max))
                modes(i, j) = v{j, 1}(1, inx_max);  
           end
        end
    end
end

end