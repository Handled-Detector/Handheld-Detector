function [result] = m_box_ss3(image)
%0901 相较于ss2，将取半高宽的三点平均操作删除，就单点操作。
%将SVD的重建图像输入后，输出应该取的box的中心位置和大小
%检查发现image的形状有问题？？？？
image = reshape(image,[181,360]);
w=fspecial('gaussian',[30 30],30);    
image=imfilter(image,w); 
[xita,phi]=find(image==max(max(image)));

%设置判定标准
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