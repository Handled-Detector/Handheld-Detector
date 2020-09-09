
function varargout = GUI_Handled_Detector(varargin)
% GUI_HANDLED_DETECTOR MATLAB code for GUI_Handled_Detector.fig
%      GUI_HANDLED_DETECTOR, by itself, creates a new GUI_HANDLED_DETECTOR or raises the existing
%      singleton*.
%
%      H = GUI_HANDLED_DETECTOR returns the handle to a new GUI_HANDLED_DETECTOR or the handle to
%      the existing singleton*.
%
%      GUI_HANDLED_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_HANDLED_DETECTOR.M with the given input arguments.
%
%      GUI_HANDLED_DETECTOR('Property','Value',...) creates a new GUI_HANDLED_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Handled_Detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Handled_Detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Handled_Detector

% Last Modified by GUIDE v2.5 08-Sep-2020 19:19:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Handled_Detector_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Handled_Detector_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% End initialization code - DO NOT EDIT
end


% --- Executes just before GUI_Handled_Detector is made visible.
function GUI_Handled_Detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Handled_Detector (see VARARGIN)

% Choose default command line output for GUI_Handled_Detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global t_info;
t_info = 0;
% UIWAIT makes GUI_Handled_Detector wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Handled_Detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    global info;
    global t_info;
    
    info = 1;
    t_info = t_info + 1;
    
    disp(info)
    if t_info == 1 
        pushbutton7_Callback(hObject, eventdata, handles);%提醒设置时间信息
    end
    axes2_ButtonDownFcn();%绘图
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    global info;%用以判定使用何种重建模式
    global t_info;
    
    info = 3;
    t_info = t_info + 1;
    
    disp(info)
    if t_info == 1 
        pushbutton7_Callback(hObject, eventdata, handles);%提醒设置时间信息
    end
    
    axes2_ButtonDownFcn();%绘图
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    %info = 4;
    global info;
    global t_info;
    
    info = 4;
    t_info = t_info + 1;
    
    disp(info)
    if t_info == 1 
        pushbutton7_Callback(hObject, eventdata, handles);%提醒设置时间信息
    end
    
    axes2_ButtonDownFcn();%绘图
    %text3_ButtonDownFcn(handles);
    
    
    
    
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
%输入坐标
    global xita;
    global phi;
    global sm;
    global proj;
    
    point = inputdlg({'xita','phi'},'请输入点坐标',1,{'90','180'});
    %input=cell2mat(point);
    xita = int16(str2double(point{1}));
    phi = int16(str2double(point{2}));

    disp(xita)
    disp(phi)
    
    %数据的加噪声必须在这里完成
    image = zeros([181,360]);
    image(xita,phi) = 1;%为了之后的验证函数不出错，这里故意写xita差一度。
    image = reshape(image,[181*360,1]);
    proj=sm * image;
    %SVD的前投影也在这,有噪声的
    proj=reshape(proj,[320,1]);
    proj = add_noise(proj);
    
    
    set(handles.text3,'string',['xita: ',num2str(xita)]);
    set(handles.text5,'string',['phi: ',num2str(phi)]);
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
%输入重建时间
    global t_mlem;
    global t_svd_mlem;

    point = inputdlg({'模式2','模式3'},'请输入重建时间',1,{'10','1'});
    %input=cell2mat(point);
    t_mlem = int16(str2double(point{1}));
    t_svd_mlem = int16(str2double(point{2}));
%打印重建时间
    set(handles.text7,'string',['模式2重建时间: ',num2str(t_mlem), 's']);
    set(handles.text8,'string',['模式3重建时间: ',num2str(t_svd_mlem), 's']);
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
%用以生成随机面源，非点源方式
    global sm;
    global proj;

    point = inputdlg({'面源个数','面源长度/2','面源宽度/2'},'请输入面源信息',1,{'3','8','8'});
    %input=cell2mat(point);

    area_num = int16(str2double(point{1}));
    area_xita = int16(str2double(point{2}));
    area_phi = int16(str2double(point{3}));
    
    
    %数据的加噪声必须在这里完成
    image = zeros([181,360]);
    
    image = square_random_defined_multi_image(area_num,area_xita,area_phi);
    image = reshape(image,[181*360,1]);
    %disp(size(sm))
    proj=sm * image;
    %SVD的前投影也在这,有噪声的
    proj=reshape(proj,[320,1]);
    proj = add_noise(proj);
    
    

    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%必要数据的前导入在此函数中完成
    global sm;
    global sm_3d;
    global s_1;
    global U;
    global V;
    load('D:\大三下小学期\SRT\0725\local_mlem_allspace\System_Matrix_MURAkeV.mat');
    load('D:\大三下小学期\SRT\0725\local_mlem_allspace\svd_econ.mat');
    
    
    sm=reshape(System_Matrix,[320,65160]);
    sm_3d = reshape(System_Matrix,[320,181,360]);
    
    
    s_1 = zeros(320,320);
    for i = 1:130%此处先暂时设为130,后续再调整
       s_1(i,i) = 1 / S(i,i);
    end
    
    
    %初始化图像
    a = zeros([181,360]);
    imagesc(a)

% Hint: place code in OpeningFcn to populate axes2
end


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % hObject    handle to axes2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global xita;
    global phi;
    global info;

    recon_image = models_3_reconfunc(info,xita,phi);
    imagesc(recon_image)
    colormapeditor;
end

function [result] = models_3_reconfunc(info, xita, phi)
    %这段代码进行辐射源定位仪的MLEM重建
%为多源版本的
%跑完后不需要joint_image再缝合图像了
global sm;
global sm_3d;
global s_1;
global U;
global V;
global proj;
global t_mlem;
global t_svd_mlem;



if info == 1   
    svd_re_f = V * s_1 * U'* proj;
    svd_re_f_image = reshape(svd_re_f,[181,360]);
    
    result = svd_re_f_image;
end
    
if info == 3
        
        recon = ones(size(sm,2),1); %这是设置迭代的初始值，记得把这个改成SVD重建的结果试试
        
        t3 = clock;
        for k = 1:50000 %迭代次数需要根据重建允许时间调整
            recon1 = (sm' * (proj./(sm * recon  + eps) + eps)) .* recon ./(sum(sm,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%这个是判断迭代是否收敛
%                  break
%             end
            recon=recon1;
            t4 = clock;
            %做重建时间的调整，预计在5秒钟内
            if etime(t4,t3) > t_mlem
                %disp(k)
                break
            end
        end
        recon_iamge = reshape(recon,[181,360]);
    
        result = recon_iamge;
end

if  info == 4
 
 
        
    svd_re_f = V * s_1 * U'* proj;
        
    %判定有几个源
    %judge
    %版本4中改为多源提取
    %tic;
    range_box = m_box_e4(svd_re_f);
    %toc;
        
        
    %disp(range_box)
        
    %disp(m_box(svd_re_f));
        
    %sm1为小矩阵
    sm1 = joint_boxes(range_box,sm_3d);
        
    %开始MLEM迭代重建
    recon = ones(size(sm1,2),1); %这是设置迭代的初始值，记得把这个改成SVD重建的结果试试
        
    t3 = clock;
    for k = 1:50000 %迭代次数需要根据重建允许时间调整
        recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%这个是判断迭代是否收敛
%                  break
%             end
        recon=recon1;
        t4 = clock;
        %做重建时间的调整，预计在一秒钟内
        if etime(t4,t3) > t_svd_mlem
            %disp(k)
            break
        end
    end
        
       
   %进行图像拼接
    recon_mlem_full = joint_recon_image(recon,range_box);
    %进行图像后处理，模糊
    %gauss_recon_mlem_full = after_gauss_image(recon_mlem_full,[10,20],2);
    
    result = recon_mlem_full;
    
end
    
end
