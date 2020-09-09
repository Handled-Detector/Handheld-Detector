
function [result] = m_box_e4(image)
%��SVD���ؽ�ͼ����������Ӧ��ȡ��box������λ�úʹ�С
svd_re_f = reshape(image,[181,360]);%svd_re_fΪԭʼͼ��
w=fspecial('gaussian',[30 30],30); %ע�������gaussģ���Ĳ�������ȡ̫С   
image_edge = imfilter(svd_re_f,w); 
image_edge = edge(image_edge,'sobel');%imageΪ����ͼ��,�����ж��Ƿ�׽������Դ
%imagesc(image)

temp_result = zeros(6,1);

%��ֹ��׼
standard = max(0.01 * sum(sum(image_edge)),3);

for i = 1:10%���֧��10��Դ���ٶ���㷨ʧȥ����
    sum_full_edge = sum(sum(image_edge));
    %sprintf('sum_full_edge=%d,standard=%d',sum_full_edge,standard)
    if sum_full_edge  > standard%�ж��Ƿ��ֹѭ��
        if i == 1
            temp_result(:,end) = m_box_ss1(svd_re_f);
        else
            temp_result(:,end+1) = m_box_ss1(svd_re_f);
        end
        %disp(temp_result);
        %�����ҵ�Դ���ֵ��ڸ�,����Ϊ�����SS2����������չ66%
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

%��ʱ����box�����ص�����
result = temp_result;
%sprintf('temp_result = %d',size(temp_result,2))
    
end