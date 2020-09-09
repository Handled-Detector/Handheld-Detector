%添加噪声
function[result] = add_noise(Proj)
%输入为一维的晶体接收数据
Replicates=1;
Nmean=sum(Proj)*0.01*3.7e10*10;%表示0.01居里，10秒钟的数据
calib=Nmean/sum(Proj);
Noise_Proj=zeros(length(Proj),1);
for n=1:length(Proj)
    y1=calib*Proj(n);
    Noise_Proj(n)=poissrnd(y1*ones(1,Replicates))/calib;
end

result = Noise_Proj;
end
