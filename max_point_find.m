load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);

%������Ҫ�Լ�����һ���洢��������·��
%pth='D:\������';


%ѡ��Ҫ�ؽ��ĽǶȣ�������Ե����Ƕȣ�ȡһ��ֵ�Ϳ���
%�˴�Ϊ������������ֻ�ѳ��ȱ�ʾ����
theta_value=1:1:121;
phi_value=1:1:301;

% theta_value = [90];
% phi_value = [180];

%����svd�ؽ�
% image_f = zeros(181,360);
% image_f(theta_value+1,phi_value) = 1;
% image_f = reshape(image_f,[181*360,1]);
load('svd_econ.mat');
s_1 = zeros(320,320);
for i = 1:160
   s_1(i,i) = 1 / S(i,i);
end
% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%�������������õı���result%ά������Ϊĳ�Ƕ��´洢��ͼ��xita��phi,��Ϊ21��

result_max_points = zeros(2,121,301);

for i=1:length(theta_value)
    disp(i)
    for j=1:length(phi_value)
        theta=theta_value(i);
        phi=phi_value(j);
        
        %����ǰͶӰ
        image=zeros(181,360);
        image(theta+29,phi+29)=1;
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD��ǰͶӰҲ����
        svd_re_f = V * s_1 * U'* proj;
        svd_re_f = reshape(svd_re_f,[181,360]);
        [x,y]=find(svd_re_f==max(max(svd_re_f)));
        result_max_points(1,theta,phi) = x;
        result_max_points(2,theta,phi) = y;
        
        

    end
    
end

save('result_max_points','result_max_points');    









