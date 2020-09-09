function [result] = joint_recon_image(recon,range_box)
%该函数输入为迭代后的结果，输出为全图的recon_image
len = size(range_box,2);
result = zeros(181,360);
if len == 1
    range_image = range_box(5)*range_box(6);
    %进行单源拆分
    recon_one_source = reshape(recon(1:range_image),[range_box(5),range_box(6)]);
    %添加拆分的单源到全图中，此处使用的为覆盖
    %result(range_box(1):range_box(2),range_box(3):range_box(4)) = recon_one_source + result(range_box(1):range_box(2),range_box(3):range_box(4));
    result(range_box(1):range_box(2),range_box(3):range_box(4)) = recon_one_source;
else
    for i  = 1:len
        range_image = range_box(5,i)*range_box(6,i);
        %进行单源拆分
        recon_one_source = reshape(recon(1:range_image),[range_box(5,i),range_box(6,i)]);
        %拆分完后置零
        recon(1:range_image) = [];
        %添加拆分的单源到全图中,此处为覆盖
        %result(range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i)) = recon_one_source + result(range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i));
        result(range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i)) = recon_one_source;
    end




end
