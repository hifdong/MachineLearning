function [modes] = InitStand(U, k_cluster)  
 %matlab version:7.13.0.564
%程序说明：聚类初始中心点选取函数
%Input:'U' -dataset ,'k_cluster' - the number of cluster  .
%Output: 'modes' -init center .

U_row = size(U, 1);
U_col = size(U, 2);
modes = zeros(k_cluster, U_col);

%计算每个属性的值域 (需要cell型存储) 
for i = 1:U_col
    V{i, 1} = [];
    V_sorted{i, 1} = [];  %用V_sorted保存排序后的属性
end

 for i = 1:U_col
   for j = 1:U_row
      if ~any(ismember(U(j, i), V{i, 1}))
         V{i,1}(1, (size(V{i, 1}, 2) + 1)) = U(j, i);
     end
   end
end

for i = 1:U_col    %属性的值域个数同值域
    fraq{i, 1} = zeros(size(V{i, 1}));
    fraq_sorted{i, 1} = zeros(size(V{i, 1}));
end 

for i = 1:U_col
   for j = 1:U_row
       ind = find(V{i, 1} == U(j, i));
        fraq{i,1}(1, ind) = fraq{i, 1}(1, ind) + 1 ;   
   end
end

%对fraq中各个属性排序
for i = 1:U_col
   [fraq_sorted{i, 1}, I] = sort(fraq{i, 1}, 'descend');    
    V_sorted{i, 1} = V{i, 1}(I); 
end

%设置modes，主属性挑选，其次随机
 for i = 1:k_cluster
    for j = 1:U_col
         if j <= k_cluster%属性下标小于类别下标部分 
                 if j == i 
                     modes(i, i) = V_sorted{i, 1}(1, 1);
                 elseif j ~= i  %随机选取一个非最高频属性值
                     size_attr =  size(V_sorted{j, 1}, 2);
                     modes(i, j) = V_sorted{j, 1}(1,  randint(1, 1, [2 size_attr]));
                 end
         elseif j > k_cluster  %属性下标超出类别下标部分
           size_attr =  size(V_sorted{j, 1}, 2);
           modes(i, j) = V_sorted{j, 1}(1,  randint(1, 1, [1 size_attr]));
         end
   end
end

end
