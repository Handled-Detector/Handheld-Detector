function [result] = after_gauss_image(recon_mlem_full,size,tao)
w=fspecial('gaussian',size,tao);    
result=imfilter(recon_mlem_full,w); 
end