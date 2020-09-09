

function [result] = m_box_e3(image)
%��SVD���ؽ�ͼ����������Ӧ��ȡ��box������λ�úʹ�С
svd_re_f = reshape(image,[181,360]);%svd_re_fΪԭʼͼ��
[xita,phi]=find(svd_re_f==max(max(svd_re_f)));
sprintf('theta=%d,phi=%d',xita,phi)
xita_max = xita;%�����ֵѰ�ҵ����ĵ㱣�棬��Ϊ���������ķ��ıȽ�
phi_max = phi;

%%ʹ����������Ŀ�����ҳ����ŵ�Դ�����ġ�
w=fspecial('gaussian',[30 30],30); %ע�������gaussģ���Ĳ�������ȡ̫С   
image=imfilter(svd_re_f,w); 
image = edge(image,'sobel');%imageΪ����ͼ��
imagesc(image)

%���ü���õ�С����ͱ��
l_xita = max(xita - 50,1);
r_xita = min(l_xita + 100,181);
d_phi = max(phi-50,1);
u_phi = min(d_phi + 100,360);

%����/�мӷ�����Ե
sum_phi = sum(image(l_xita:r_xita,d_phi:u_phi));
sum_xita = sum((image(l_xita:r_xita,d_phi:u_phi)'));
%���ܻ��������õ������Բ�ı�Ե�����Ч�����ܺ�

%max_x = imregionalmax(sum_x).*sum_x;%����ֵ��⣬��������ֵ��ֵ
%max_phi = imregionalmax(sum_phi).*sum_phi;

%sm_x = find(sum_x(1:xita - l_x)==max(sum_x(1:xita-l_x)),1,'last');%����������ֵ����Ҫmax
%bg_x = xita - l_x - 1 + find(sum_x(xita - l_x : r_x - l_x + 1)==max(sum_x(xita - l_x : r_x - l_x + 1)),1,'first');
%sprintf('sm_x=%d,bg_x=%d',sm_x,bg_x)
%bg_phi = phi - d_phi - 1 + find(sum_phi(phi - d_phi : u_phi - d_phi + 1)==max(sum_phi(phi - d_phi : u_phi - d_phi + 1)),1,'first');
%sm_phi = find(sum_phi(1 : phi - d_phi)==max(sum_phi(1 : phi - d_phi)),1,'last');
sm_xita = mean(find(sum_xita(1:xita - l_xita)==max(sum_xita(1:xita-l_xita))));
bg_xita = xita - l_xita - 1 + mean(find(sum_xita(xita - l_xita : r_xita - l_xita + 1)==max(sum_xita(xita - l_xita : r_xita - l_xita + 1))));
bg_phi = phi - d_phi - 1 + mean(find(sum_phi(phi - d_phi : u_phi - d_phi + 1)==max(sum_phi(phi - d_phi : u_phi - d_phi + 1))));
sm_phi = mean(find(sum_phi(1 : phi - d_phi)==max(sum_phi(1 : phi - d_phi))));

xita = round(l_xita + (bg_xita + sm_xita)/2);
phi = round(d_phi + (bg_phi + sm_phi)/2);
%%��� �ҵ�����xita\phi
sprintf('c_x=%d,l_x=%d,bg_x=%d,sm_x=%d',xita,l_xita,bg_xita,sm_xita)
sprintf('c_phi=%d,d_phi=%d,bg_phi=%d,sm_phi=%d',phi,d_phi,bg_phi,sm_phi)

list = 1:5:31;
standard = svd_re_f(xita,phi)/2.5;

for i = list
    if sum(svd_re_f(xita-10-i,phi-1:phi+1))/3 < standard
        sm_xitat = xita-10-i;
        break;
    end
end
for i = list
    if sum(svd_re_f(xita+10+i,phi-1:phi+1))/3 < standard
        bg_xitat = xita+10+i;
        break;
    end
end
for j = list
    if sum(svd_re_f(xita-1:xita+1,phi+10+j))/3 < standard
        bg_phit = phi+10+j;
        break;
    end
end
for j = list
    if sum(svd_re_f(xita-1:xita+1,phi-10-j))/3 < standard
        sm_phit = phi-10-j;
        break;
    end
end  

xita_box = bg_xitat - sm_xitat + 1;
phi_box = bg_phit - sm_phit + 1;
result = [sm_xitat,bg_xitat,sm_phit,bg_phit,xita_box,phi_box,xita,phi,xita_max,phi_max];%�����ǰ6�����ã�����Ϊ�����



%disp(x_range);
%disp(phi_range);
end

