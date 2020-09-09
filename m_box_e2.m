
function [result] = m_box_e2(image)
%��SVD���ؽ�ͼ����������Ӧ��ȡ��box������λ�úʹ�С
svd_re_f = reshape(image,[181,360]);
[x,y]=find(svd_re_f==max(max(svd_re_f)));
%disp(x);
%disp(y);

w=fspecial('gaussian',[30 30],30);    
svd_re_f=imfilter(svd_re_f,w);        
image = edge(svd_re_f,'sobel');

%���ü���׼
standard = 0.95*sum(sum(image(max(x-50,1):min(x+50,181),max(y-50,1):min(y+50,360))));

%����ѭ��list��ѭ���ж�info
list = 1:5:31;
info = 0;
for i = list
    for j = list
        %disp(i)
        %disp(j)
        left_x = max(x-10-i,1);
        right_x = min(x+10+i,181);
        up_y = min(y+10+j,360);
        down_y = max(y-10-j,1);
        if sum(sum(image(left_x:right_x,down_y:up_y))) > standard 
            info = 1;
            break;
        end
        
    end
    if info == 1
        break;   
    end
end
%�����ղ����������ȽϺ�
left_x = max(x-15-i,1);
right_x = min(x+15+i,181);
up_y = min(y+15+j,360);
down_y = max(y-15-j,1);

result = [left_x,right_x,down_y,up_y,right_x - left_x + 1,up_y - down_y + 1];



%disp(x_range);
%disp(y_range);
end