
function [result] = m_box_e4(image)
%将SVD的重建图像输入后，输出应该取的box的中心位置和大小
svd_re_f = reshape(image,[181,360]);%svd_re_f为原始图像
w=fspecial('gaussian',[30 30],30); %注意这里的gauss模糊的参数不能取太小   
image_edge = imfilter(svd_re_f,w); 
image_edge = edge(image_edge,'sobel');%image为轮廓图像,用以判定是否捕捉完所有源
%imagesc(image)

temp_result = zeros(6,1);

%截止标准
standard = max(0.01 * sum(sum(image_edge)),3);

for i = 1:10%最多支持10个源，再多该算法失去意义
    sum_full_edge = sum(sum(image_edge));
    %sprintf('sum_full_edge=%d,standard=%d',sum_full_edge,standard)
    if sum_full_edge  > standard%判定是否截止循环
        if i == 1
            temp_result(:,end) = m_box_ss1(svd_re_f);
        else
            temp_result(:,end+1) = m_box_ss1(svd_re_f);
        end
        %disp(temp_result);
        %进行找到源部分的遮盖,这里为了配合SS2，将向外拓展66%
        extra_xita_range = round(temp_result(5,end)/3);
        extra_phi_range = round(temp_result(6,end)/3);
        
        temp_sm_xita = max(temp_result(1,end)-extra_xita_range,1);
        temp_bg_xita = min(temp_result(2,end)+extra_xita_range,181);
        temp_sm_phi = max(temp_result(3,end)-extra_phi_range,1);
        temp_bg_phi = min(temp_result(4,end)+extra_phi_range,360);
        temp_xita_range = temp_bg_xita - temp_sm_xita + 1;
        temp_phi_range = temp_bg_phi - temp_sm_phi + 1;
        
        
        image_edge(temp_sm_xita:temp_bg_xita,temp_sm_phi:temp_bg_phi) = zeros(temp_xita_range,temp_phi_range);
        svd_re_f(temp_result(1,end):temp_result(2,end),temp_result(3,end):temp_result(4,end)) = zeros(temp_result(5,end),temp_result(6,end));
        imagesc(image_edge);
    else
        break;
    end
end

%暂时不管box可能重叠问题
result = temp_result;
%sprintf('temp_result = %d',size(temp_result,2))
    
end