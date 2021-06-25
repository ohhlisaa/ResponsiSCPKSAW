function varargout = Nomor2(varargin)
% NOMOR2 MATLAB code for Nomor2.fig
%      NOMOR2, by itself, creates a new NOMOR2 or raises the existing
%      singleton*.
%
%      H = NOMOR2 returns the handle to a new NOMOR2 or the handle to
%      the existing singleton*.
%
%      NOMOR2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOMOR2.M with the given input arguments.
%
%      NOMOR2('Property','Value',...) creates a new NOMOR2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Nomor2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Nomor2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Nomor2

% Last Modified by GUIDE v2.5 25-Jun-2021 22:09:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Nomor2_OpeningFcn, ...
                   'gui_OutputFcn',  @Nomor2_OutputFcn, ...
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


% --- Executes just before Nomor2 is made visible.
function Nomor2_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Nomor2 (see VARARGIN)

% Choose default command line output for Nomor2
handles.output = hObject;
opts = detectImportOptions('DATA RUMAH.xlsx');
%mendeteksi file dataset DATA RUMAH.xlsx
opts.SelectedVariableNames = [1,3,4,5,6,7,8];
%mengambil variabel pada kolom 1,3,4,5,6,7,8 di DATA RUMAH.xlsx
data = readmatrix('DATA RUMAH.xlsx', opts);
%menempatkan data dari excel ke variabel data
set(handles.uitable2, 'Data',data);
%mengambil dan menampilkan data DATA RUMAH.xlxs di uitable2


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Nomor2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Nomor2_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('DATA RUMAH.xlsx'); 
%mendeteksi file dataset DATA RUMAH.xlsx
opts.SelectedVariableNames = [3,4,5,6,7,8]; 
%mengambil data kolom 3 sampai 8

data = readmatrix('DATA RUMAH.xlsx',opts); 
%menempatkan data dari excel ke variabel data

k=[0,1,1,1,1,1];
%memberi nilai atribut dimana 0= atribut biaya  dan 1= atribut keuntungan
w=[0.30, 0.20, 0.23, 0.10, 0.07, 0.10];
%memberi bobot untuk masing-masing kriteria

%tahapan 1. normalisasi matriks
[m,n]=size (data); 
%matriks m x n dengan ukuran sebanyak variabel data input
R=zeros (m,n); 
%membuat matriks R, yang merupakan matriks kosong

for j=1:n
    if k(j)==1 %statement untuk kriteria dengan atribut keuntungan
        R(:,j)=data(:,j)./max(data(:,j));
    else
        R(:,j)=min(data(:,j))./data(:,j); %statement untuk kriteria dengan atribut biaya
    end
end

%tahapan kedua, proses penjumlahan dan perkalian dengan bobot sesuai kriteria
for i=1:m
    V(i)= sum(w.*R(i,:));
end

%tahapan ketiga, proses perangkingan
nilai = sort(V,'descend');

%perulangan memilih 20 nilai terbaik 
for i=1:20
hasil(i) = nilai(i);
end

opts2 = detectImportOptions('DATA RUMAH.xlsx'); 
%mendeteksi file DATA RUMAH.xlsx
opts2.SelectedVariableNames = [2]; 
%memilih kolom Nama Rumah

nama = readmatrix('DATA RUMAH.xlsx',opts2); 
%mengambil nama rumah dari file dan menyimpan di variabel nama

%perulangan untuk mencari nama rumah dari 20 nilai terbaik 
for i=1:20
 for j=1:m
   if(hasil(i) == V(j))
    rekomendasi(i) = nama(j);
    break
   end
 end
end
%melakukan transpose pada rekomendasi agar tampilan menjadi per baris
rekomendasi = rekomendasi';

set(handles.uitable3,'Data',rekomendasi);
%mengambil dan menampilkan data rekomendasi di uitable3

% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
