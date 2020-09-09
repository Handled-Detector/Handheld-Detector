function [result,info] = square_random_image()
%用以随机生成(1,1)->(41,41)大小的面源
x_range = round(unifrnd (1,20));
y_range = round(unifrnd (1,20));
result = ones(2 * y_range + 1,2 * x_range + 1);
info = [x_range,y_range];

sprintf('x_range=%d,y_range=%d',x_range,y_range)
end