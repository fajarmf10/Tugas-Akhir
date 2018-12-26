function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 10-Apr-2016 19:09:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no out args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line out for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning out args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line out from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btinput.
function btinput_Callback(hObject, eventdata, handles)
% hObject    handle to btinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%reset semua axes untuk menampilkan input&out baru
cla(handles.inp,'reset');
set(handles.inp,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.interactive,'reset');
set(handles.interactive,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.merge,'reset');
set(handles.merge,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.out,'reset');
set(handles.out,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');

[filename, pathname] = uigetfile('*.tif;*.jpg;*.png;*.bmp','Pick an Image File');
iminput = imread([pathname, filename]);

if size(iminput,3) == 3
    iminput = rgb2gray(iminput);
end
iminput = im2double(iminput);
assignin('base', 'iminput', iminput);
assignin('base', 'fileinput', filename);

set(handles.inp,'HandleVisibility', 'ON');
axes(handles.inp);
imshow(iminput);
handles.im_input = iminput;
guidata(hObject, handles);


% --- Executes on button press in btgt.
function btgt_Callback(hObject, eventdata, handles)
% hObject    handle to btgt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.gt,'reset');
set(handles.gt,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.interactive,'reset');
set(handles.interactive,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.merge,'reset');
set(handles.merge,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.out,'reset');
set(handles.out,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');

[filegt, pathgt] = uigetfile('*.tif;*.jpg;*.png;*.bmp','Pick an Image File');
imgt  = imread([pathgt, filegt]);
imgt = (im2bw(imgt)*255);

assignin('base', 'imgt', imgt);
set(handles.gt,'HandleVisibility', 'ON');
axes(handles.gt);
imshow(imgt);
handles.im_gt = imgt;
guidata(hObject, handles);


% --- Executes on button press in btproses.
function btproses_Callback(hObject, eventdata, handles)
% hObject    handle to btproses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerValue = 0;
handles.marker = markerValue;
set(handles.bgmarker,'Value',0);
set(handles.objmarker,'Value',0);
guidata(hObject, handles);

I = handles.im_input;
if (~isdeployed)
    addpath('edison_matlab_interface/');
end

hs = 7;
hr = 10;
M = 11;
[S L] = msseg(I,hs,hr,M);
% figure, imshow(S);

% tes = [evalin('base', 'fileinput')];
% tes = regexp(tes, '[.]', 'split');
% % program_folder = pwd
% tes2 = strcat(pwd,'\Data ROI\MS\');
% tes2 = strcat(tes2,tes{1});
% assignin('base', 'tes', tes2);
% tes2 = strcat(tes2, '_segm.png');
% S = imread(tes2);
% figure, imshow(L);

Lbaru = padarray(L, [1 1], 'replicate', 'both');
A = ones(size(Lbaru));

for (i=2:(size(Lbaru,1)-1))
    for (j=2:(size(Lbaru,2)-1))
            % kanan
            if (Lbaru(i,j) ~= Lbaru(i,j+1))
                A(i,j) = 0;
            end
            if (Lbaru(i,j) ~= Lbaru(i+1,j))
                A(i,j) = 0;
            end
            % kanan bawah
            if (Lbaru(i,j) ~= Lbaru(i+1,j+1))
                A(i,j) = 0;
            end
    end
end

A = A(((2:(size(Lbaru,1)-1))), ((2:(size(Lbaru,2)-1))));
% figure, imshow(A);

I = im2single(I);
imreg = ones(size(I));
for (i=1:(size(A,1)))
    for (j=1:(size(A,2)))
        if (A(i,j) == 0)
            imreg(i,j,:) = 1;
        else imreg(i,j,:) = I(i,j,:);
        end
    end
end
        
assignin('base', 'L', L);

set(handles.interactive,'HandleVisibility', 'ON');
axes(handles.interactive);
imshow(imreg);
handles.im_reg = imreg;
handles.label = L;
guidata(hObject, handles);
% imwrite(imreg, 'E:\Raras\Kuliah\Semester 3\Program\Result\split.png', 'WriteMode', 'overwrite'); 
% imwrite(A, 'D:\0Desktop\Raras 2015\Semester 2\Zemi\Otsu Multicluster\result\1_IniSeg.png', 'WriteMode', 'overwrite'); 

% --- Executes on button press in objmarker.
function objmarker_Callback(hObject, eventdata, handles)
% hObject    handle to objmarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerValue = 0;
set(handles.bgmarker,'Value',0);
if (get(hObject,'Value') == 1)
    markerValue = 1;
end

handles.marker = markerValue;
guidata(hObject, handles);

axes(handles.interactive);

obj_x = [];
obj_y = [];
status = 1;
while (status ~= -1)
    [myobj,xs,ys,status] = freehanddraw3(gca,'color','r','linewidth',3);
    obj_x = [obj_x; round(xs)];
    obj_y = [obj_y; round(ys)];
end

assignin('base', 'obj_x', obj_x);
assignin('base', 'obj_y', obj_y);

handles.obj_x = obj_x;
handles.obj_y = obj_y;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of objmarker

% --- Executes on button press in bgmarker.
function bgmarker_Callback(hObject, eventdata, handles)
% hObject    handle to bgmarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerValue = 0;
set(handles.objmarker,'Value',0);
if (get(hObject,'Value') == 1)
    markerValue = 2;
end

handles.marker = markerValue;
guidata(hObject, handles);

axes(handles.interactive);

bg_x = [];
bg_y = [];
status = 1;
while (status ~= -1)
    [mybg,xs,ys,status] = freehanddraw3(gca,'color','b','linewidth',3);
    bg_x = [bg_x; round(xs)];
    bg_y = [bg_y; round(ys)];
end

assignin('base', 'bg_x', bg_x);
assignin('base', 'bg_y', bg_y);

handles.bg_x = bg_x;
handles.bg_y = bg_y;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of bgmarker


% --- Executes on button press in btmerge.
function btmerge_Callback(hObject, eventdata, handles)
% hObject    handle to btmerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = waitbar(0,'Initiating region merging process..');

obj_x = handles.obj_x ;
obj_y = handles.obj_y ;
bg_x = handles.bg_x ;
bg_y = handles.bg_y ;
L_lama = handles.label;
im_input_lama = handles.im_input;
im_gt = handles.im_gt;

% input setelah user marking
% inputNew = im_input_lama;
% for i=1:size(obj_x,1)
%     inputNew(obj_x(i),obj_y(i))=1.0;
% end
% for i=1:size(bg_x,1)
%     inputNew(bg_x(i), bg_y(i))=0.0;
% end
save('im_input_lama.mat','im_input_lama');

% membuat obj dan bg awal

z=1;
for i=1:size(im_input_lama,1)
    for j=1:size(im_input_lama,2)
        L(z) = L_lama(i,j);
        z = z+1;
    end
end

save('L_lama.mat','L_lama');

obj_ind = (obj_y-1)*size(im_input_lama,2) + obj_x;
bg_ind = (bg_y-1)*size(im_input_lama,2) + bg_x;
obj = unique(L(obj_ind));
bg = unique(L(bg_ind));

waitbar(5/100, h, sprintf('List the marked regions..'));
save('obj.mat','obj');
save('bg.mat','bg');

% membuat ck

gabungan = [obj bg];
member = ismember(L,gabungan);
ck_awal = unique(L(member==0));
disp(size(ck_awal));
ck = ones(size(ck_awal,2));
ck(:,1) = ck_awal;

assignin('base', 'ck', ck);

tic
[im_output_link, h] = merge_linkage( obj, bg, im_input_lama, L_lama, ck, h );
toc

tic
im_output_ori = merge_ori( obj, bg, im_input_lama, L_lama, ck );
toc

set(handles.merge,'HandleVisibility', 'ON');
axes(handles.merge);
imshow(im_output_link);

% [labeledImage, numberReg] = bwlabel(im_output);
% ObjMeasurements = regionprops(labeledImage, 'area');
% allAreas = [ObjMeasurements.Area];
% [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
% biggest = ismember(labeledImage, sortIndexes(1:1));
% im_final = biggest > 0;
im_final_link = imfill(im_output_link, 'holes');
imwrite(im_final_link, 'result_linkage.png', 'WriteMode', 'overwrite');

waitbar(100/100, h, sprintf('Evaluating the segmentation error..'));

% imwrite(im_final*255, 'E:\Raras\Kuliah\Semester 3\Program\Result\output.png', 'WriteMode', 'overwrite'); 
set(handles.out,'HandleVisibility', 'ON');
axes(handles.out);
imshow(im_final_link);

me_eval_link = misclas_error(im_gt,im_final_link*255);
rae_eval_link = rae(im_gt,im_final_link*255);
set(handles.txtme, 'String', ['Nilai ME = ' num2str(me_eval_link)]);
set(handles.txtrae, 'String', ['Nilai RAE = ' num2str(rae_eval_link)]);

comparison;
handComp = findobj('Tag','comparison');
if ~isempty(handComp)
    % get handles and other user-defined data associated to Gui1
    hand = guidata(handComp);

    % maybe you want to set the text in Gui2 with that from Gui1
    set(hand.merge_comp,'HandleVisibility', 'ON');
    axes(hand.merge_comp);
    imshow(im_output_ori);
    
    im_final_ori = imfill(im_output_ori, 'holes');
    imwrite(im_final_ori, 'result_ori.png', 'WriteMode', 'overwrite');
    set(hand.out_comp,'HandleVisibility', 'ON');
    axes(hand.out_comp);
    imshow(im_final_ori);
    
    me_eval_ori = misclas_error(im_gt,im_final_ori*255);
    rae_eval_ori = rae(im_gt,im_final_ori*255);
    set(hand.txtme_comp, 'String', ['Nilai ME = ' num2str(me_eval_ori)]);
    set(hand.txtrae_comp, 'String', ['Nilai RAE = ' num2str(rae_eval_ori)]);
    
%     set(handles.text1,'String',get(g1data.edit1,'String'));
% %   maybe you want to get some data that was saved to the Gui1 app
%     x = getappdata(h,'x');
end
 
close(h)


% --- Executes on button press in btreset.
function btreset_Callback(hObject, eventdata, handles)
% hObject    handle to btreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on btproses and none of its controls.
function btproses_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btproses (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




