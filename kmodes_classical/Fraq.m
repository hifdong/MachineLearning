function [f, V] = Fraq(X)  
 %matlab version:7.13.0.564
%程序说明：数据集属性的属性值频率计算函数
%Input:'X'  -dataset.
%Output:'f' -attribute's frequency ,'V' -attribute's value .
%计算指定集合的属性频率
%计算每个属性的值域 (需要cell型存储) 
[n, p] = size(X);
 for i = 1:p
      V{i, 1} = [];
end

 for i = 1:p
   for j = 1:n
      if ~any(ismember(X(j, i), V{i, 1}))
         V{i,1}(1, (size(V{i, 1}, 2) + 1)) = X(j, i);
     end
   end
end

for i = 1:p    %属性的值域个数同值域
    f{i, 1} = zeros(size(V{i, 1})); 
end 

for i = 1:p
   for j = 1:n
       ind = find(V{i, 1} == X(j, i));
        f{i,1}(1, ind) = f{i, 1}(1, ind) + 1 ;   
   end
end

end
