function [result] = m_box_ss1(image)
%���ڱ���Դ���Һ������ã��������ͼ���һ��Դ

svd_re_f = reshape(image,[181,360]);
[xita,phi]=find(svd_re_f==max(max(svd_re_f)));

w=fspecial('gaussian',[30 60],30);    
svd_re_f=imfilter(svd_re_f,w);        
image = edge(svd_re_f,'sobel');

%����ѭ��list��ѭ���ж�info
list = 1:5:31;
phi_range = [];

for i = list
    
    sm_xita = max(xita-10-i,1);
    bg_xita = min(xita+10+i,181);
    
    for j = list
        %disp(i)
        %disp(j)
        
        
        bg_phi = min(phi+10+j,360);
        sm_phi = max(phi-10-j,1);
        sum_box = sum(sum(image(sm_xita:bg_xita,sm_phi:bg_phi)));
        %�����ж��Ĳ���Ϊ5
        bg2_phi = min(phi+15+j,360);
        sm2_phi = max(phi-15-j,1);
        sum2_box = sum(sum(image(sm_xita:bg_xita,sm2_phi:bg2_phi)));
        
        if  sum2_box - sum_box < 2 
            phi_range(end+1) = j;%��ȡÿ��xitaȡphiƽ��������
            break;
        end
        
    end
    
    sm2_xita = max(xita-15-i,1);
    bg2_xita = min(xita+15+i,181);
    sum2_box = sum(sum(image(sm2_xita:bg2_xita,sm_phi:bg_phi)));
    
    if sum2_box - sum_box < 2 
        break; 
    end
    
end
%�����ղ����������ȽϺ�
j_phi = round(mean(phi_range));

sm_xita = max(xita-15-i,1);
bg_xita = min(xita+15+i,181);
bg_phi = min(phi+15+j_phi,360);
sm_phi = max(phi-15-j_phi,1);

result = [sm_xita,bg_xita,sm_phi,bg_phi,bg_xita - sm_xita + 1,bg_phi - sm_phi + 1];



%disp(x_range);
%disp(y_range);
end