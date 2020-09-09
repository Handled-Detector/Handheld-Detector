function [result] = m_box_ss3(image)
%0901 �����ss2����ȡ��߿������ƽ������ɾ�����͵��������
%��SVD���ؽ�ͼ����������Ӧ��ȡ��box������λ�úʹ�С
%��鷢��image����״�����⣿������
image = reshape(image,[181,360]);
w=fspecial('gaussian',[30 30],30);    
image=imfilter(image,w); 
[xita,phi]=find(image==max(max(image)));

%�����ж���׼
standard = image(xita,phi)/2;
list = 1:5:31;

for i = list
    temp_xita = max(1,xita-10-i);
    if image(temp_xita,phi) < standard
        sm_xita = temp_xita;
        break;
    end
    if i == 31
        sm_xita = temp_xita;
    end
end
for i = list
    temp_xita = min(181,xita+10+i);
    if image(temp_xita,phi) < standard
        bg_xita = temp_xita;
        break;
    end
    if i == 31
        bg_xita = temp_xita;
    end
end
for j = list
    temp_phi = min(360,phi+10+j);
    if image(xita,temp_phi) < standard
        bg_phi = temp_phi;
        break;
    end
    if j == 31
        bg_phi = temp_phi;
    end
end
for j = list
    temp_phi = max(1,phi-10-j);
    if image(xita,temp_phi) < standard
        sm_phi = temp_phi;
        break;
    end
    if j == 31
        sm_phi = temp_phi;
    end
end  

result = [sm_xita,bg_xita,sm_phi,bg_phi,bg_xita - sm_xita + 1,bg_phi - sm_phi + 1];



%disp(x_range);
%disp(y_range);
end