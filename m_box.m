function [result] = m_box(image)
%将SVD的重建图像输入后，输出应该取的box的中心位置和大小
%检查发现image的形状有问题？？？？
image = reshape(image,[181,360]);
[x,y]=find(image==max(max(image)));
sprintf('x=%d,y=%d',x,y)

for i = 1:5:31
    if sum(image(x-10-i,y-1:y+1))/3 < image(x,y)/2
        left_x = x-10-i;
        break;
    end
end
for i = 1:5:31
    if sum(image(x+10+i,y-1:y+1))/3 < image(x,y)/2
        right_x = x+10+i;
        break;
    end
end
for j = 1:5:31
    if sum(image(x-1:x+1,y+10+j))/3 < image(x,y)/2
        up_y = y+10+j;
        break;
    end
end
for j = 1:5:31
    if sum(image(x-1:x+1,y-10-j))/3 < image(x,y)/2
        down_y = y-10-j;
        break;
    end
end  

result = [left_x,right_x,down_y,up_y,right_x - left_x + 1,up_y - down_y + 1];



%disp(x_range);
%disp(y_range);
end
