function [modes] = InitStand(U, k_cluster)  
 %matlab version:7.13.0.564
%����˵���������ʼ���ĵ�ѡȡ����
%Input:'U' -dataset ,'k_cluster' - the number of cluster  .
%Output: 'modes' -init center .

U_row = size(U, 1);
U_col = size(U, 2);
modes = zeros(k_cluster, U_col);

%����ÿ�����Ե�ֵ�� (��Ҫcell�ʹ洢) 
for i = 1:U_col
    V{i, 1} = [];
    V_sorted{i, 1} = [];  %��V_sorted��������������
end

 for i = 1:U_col
   for j = 1:U_row
      if ~any(ismember(U(j, i), V{i, 1}))
         V{i,1}(1, (size(V{i, 1}, 2) + 1)) = U(j, i);
     end
   end
end

for i = 1:U_col    %���Ե�ֵ�����ֵͬ��
    fraq{i, 1} = zeros(size(V{i, 1}));
    fraq_sorted{i, 1} = zeros(size(V{i, 1}));
end 

for i = 1:U_col
   for j = 1:U_row
       ind = find(V{i, 1} == U(j, i));
        fraq{i,1}(1, ind) = fraq{i, 1}(1, ind) + 1 ;   
   end
end

%��fraq�и�����������
for i = 1:U_col
   [fraq_sorted{i, 1}, I] = sort(fraq{i, 1}, 'descend');    
    V_sorted{i, 1} = V{i, 1}(I); 
end

%����modes����������ѡ��������
 for i = 1:k_cluster
    for j = 1:U_col
         if j <= k_cluster%�����±�С������±겿�� 
                 if j == i 
                     modes(i, i) = V_sorted{i, 1}(1, 1);
                 elseif j ~= i  %���ѡȡһ�������Ƶ����ֵ
                     size_attr =  size(V_sorted{j, 1}, 2);
                     modes(i, j) = V_sorted{j, 1}(1,  randint(1, 1, [2 size_attr]));
                 end
         elseif j > k_cluster  %�����±곬������±겿��
           size_attr =  size(V_sorted{j, 1}, 2);
           modes(i, j) = V_sorted{j, 1}(1,  randint(1, 1, [1 size_attr]));
         end
   end
end

end
