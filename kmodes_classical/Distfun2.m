function D = distfun2(X, Center)
 %matlab version:7.13.0.564
%程序说明：距离计算函数
%Input: 'X' -dataset ,'Center' -class center .
%Output:  'D' -distance.
global V;
    [n,p] = size(X);
    D = zeros(n,size(Center,1));
    nclusts = size(Center,1);

 %距离计算,D为 n行k列
 [fra, V] = Fraq(X) ;
 
     for k = 1:n
         for i = 1:nclusts
           
               sum = 0;
             for  j = 1:p
                 if(X(k, j) ~= Center(i, j))
                    index_x = find(X(k, j) == V{j, 1});
                    index_c = find(Center(i, j) == V{j, 1});
                    nx = fra{j, 1}(1, index_x);
                    nc = fra{j, 1}(1, index_c);  
                    rat_xc = (nx + nc)/(nx * nc);
                 else
                    rat_xc = 0;
                 end
                 sum = sum + rat_xc;
             end
            D(k, i) = sum;
         end   
       end

end
