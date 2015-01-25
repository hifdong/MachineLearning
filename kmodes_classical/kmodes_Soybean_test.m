%matlab version:7.13.0.564
%程序说明：k-modes聚类算法测试程序，验证在soybean数据集上聚类结果
%输入：soybean数据集
%输出：评价指标CU，样本索引cidx,迭代次数cidx
%作者：董汉芳
clc;
clear;
%读取soybean数据，attrib为数据集中属性，class为样本对应类别编号
[attrib1,attrib2,attrib3,attrib4,attrib5,attrib6,attrib7,attrib8,attrib9,attrib10,...
    attrib11,attrib12,attrib13,attrib14,attrib15,attrib16,attrib17,attrib18,attrib19,attrib20,attrib21,...
    attrib22,attrib23,attrib24,attrib25,attrib26,attrib27,attrib28,attrib29,attrib30,attrib31,attrib32,...
    attrib33,attrib34,attrib35,class]=textread('..\data\soybean-small.data',...
    '%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%s');
soybean_mat=[attrib1';attrib2';attrib3';attrib4';attrib5';attrib6';attrib7';attrib8';attrib9';attrib10';...
    attrib11';attrib12';attrib13';attrib14';attrib15';attrib16';attrib17';attrib18';attrib19';attrib20';...
    attrib21';attrib22';attrib23';attrib24';attrib25';attrib26';attrib27';attrib28';attrib29';attrib30';...
    attrib31';attrib32';attrib33';attrib34';attrib35']';
class_id = class';
 %cidx为聚类后样本对应的类别编号，ctrs为聚类中心，sumD为目标函数值
[cidx, ctrs, sumD] = kmodes_classical(soybean_mat, 4);

indx_c1 = [];indx_c2 = [];indx_c3 = [];indx_c4 = [];
for i = 1:size(cidx)

   temp_id = class_id{1, i};
    if  2 == sum( temp_id == 'D1',2)
        indx_c1(1, size(indx_c1) + 1) = i;
    elseif  2 == sum( temp_id == 'D2',2)
        indx_c2(1, size(indx_c2) + 1) = i;
    elseif  2 == sum( temp_id == 'D3',2)
        indx_c3(1, size(indx_c3) + 1) = i;
    elseif  2 == sum( temp_id == 'D4',2)
        indx_c4(1, size(indx_c4) + 1) = i;
    end
end

   %查找出现次数最多元素
   element_c1 = cidx(indx_c1);
   element_c2 = cidx(indx_c2);
   element_c3 = cidx(indx_c3);
   element_c4 = cidx(indx_c4);
   
   table_c1=tabulate(element_c1);
    [F1, I1]=max(table_c1(:,2));

    class_d1 = table_c1(I1,1);
  
    table_c2=tabulate(element_c2);
    [F2, I2] = max(table_c2(:,2));
    class_d2 = table_c2(I2,1);
    
    table_c3 = tabulate(element_c3);
    [F3, I3] = max(table_c3(:,2));
    class_d3 = table_c3(I3,1);
   
    table_c4=tabulate(element_c4);
    [F4, I4] = max(table_c4(:,2));
    class_d4 = table_c4(I4,1);
   

   rate_c1 = F1 / size(indx_c1, 2)
   rate_c2 = F2 / size(indx_c2, 2)
   rate_c3 = F3 / size(indx_c3, 2)
   rate_c4 = F4 / size(indx_c4, 2)
   
cidx

[f, gValue] = Fraq(soybean_mat);
addpath ../MKM_NDM;
CU = compute_CU(soybean_mat, 4, cidx, gValue)
