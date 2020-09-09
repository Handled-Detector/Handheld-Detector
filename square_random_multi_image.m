function [result] = square_random_multi_image()
%用以随机生成2~5个大小为(1,1)->(31,31)大小的面源,输出为完整的面源图像
num_sources = round(unifrnd (2,5));

result = zeros(181,360);
xita_list = 30:30:151;
phi_list = 30:30:331;
%info = 
for i = 1 : num_sources
    %每个源的位置间隔至少为30°，以免重合。
    po_xita = round(unifrnd (1,5));
    po_phi = round(unifrnd (1,11));
    
    xita_range = round(unifrnd (8,12));
    phi_range = round(unifrnd (8,12));
      
    result(xita_list(po_xita)-xita_range : xita_list(po_xita)+xita_range , phi_list(po_phi)-phi_range : phi_list(po_phi)+phi_range ) = ones(2 * xita_range + 1,2 * phi_range + 1);

end
%sprintf('num_sources=%d',num_sources)
end