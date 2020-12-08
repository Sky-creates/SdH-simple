function varargout = SdH_GUI(varargin)
% SDH_GUI MATLAB code for SdH_GUI.fig
%      SDH_GUI, by itself, creates a new SDH_GUI or raises the existing
%      singleton*.
%
%      H = SDH_GUI returns the handle to a new SDH_GUI or the handle to
%      the existing singleton*.
%
%      SDH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SDH_GUI.M with the given input arguments.
%
%      SDH_GUI('Property','Value',...) creates a new SDH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SdH_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SdH_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SdH_GUI

% Last Modified by GUIDE v2.5 23-Jan-2019 15:36:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SdH_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SdH_GUI_OutputFcn, ...
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

% --- Executes just before SdH_GUI is made visible.
function SdH_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SdH_GUI (see VARARGIN)

% Choose default command line output for SdH_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SdH_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = SdH_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in selectdata1.
% read data file 1, containing peak information at a fixed temperature
function selectdata1_Callback(hObject, eventdata, handles)
% hObject    handle to selectdata1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% defining some useful constants
h=6.6260755e-34;
e=1.602176565e-19;
kB=1.3806505e-23;
me=9.10938215e-31;

% open file
[filename,filepath]=uigetfile('*.dat','打开文件');
filep=strcat(filepath,filename);
data1=importdata(filep);
[n1,~]=size(data1);
global Bdata
global Adata
global Aerror
global flag_Dingle
global frequency
global intercept
global kF

flag_Dingle=0;  % whether to perform Dingle fitting
% classify data
if get(handles.Bstyle,'value')==2
    Bdata=1./data1(:,1);
else
    Bdata=data1(:,1);
end
if get(handles.errorBstyle,'value')==3
    Berror=data1(:,2)./data1(:,1).^2;
    ndata=data1(:,3);
    if get(handles.amplitudedata,'value')==2
        flag_Dingle=1;
        Adata=data1(:,4);
        if get(handles.amplitudeerror,'value')==2
            Aerror=data1(:,5);
        else
            Aerror=ones(n,1);
        end
    end
end
 if get(handles.errorBstyle,'value')==2
    Berror=data1(:,2);
    ndata=data1(:,3);
    if get(handles.amplitudedata,'value')==2
        flag_Dingle=1;
        Adata=data1(:,4);
        if get(handles.amplitudeerror,'value')==2
            Aerror=data1(:,5);
        else
            Aerror=ones(n1,1);
        end
    end
 end
if get(handles.errorBstyle,'value')==1
    Berror=ones(n1,1);
    ndata=data1(:,2);
    if get(handles.amplitudedata,'value')==2
        flag_Dingle=1;
        Adata=data1(:,3);
        if get(handles.amplitudeerror,'value')==2
            Aerror=data1(:,4);
        else
            Aerror=ones(n1,1);
        end
    end
end
% Landau level fan diagram
LLfan=fit(ndata,Bdata,'poly1','weights',1./Berror);
axes(handles.axes1);
cla reset
plot_x=[-1,intercept,max(ndata)+2]';
plot(plot_x,LLfan(plot_x));
hold on
xlabel 'n'
ylabel '1/B(T^-^1)'
if(get(handles.errorBstyle,'value')~=1)
    errorbar(ndata,Bdata,Berror,'.')
else
    scatter(ndata,Bdata)
end
scatter([-LLfan.p2/LLfan.p1],[0]);
legend('fitting','data')
hold off
frequency=1/LLfan.p1;
intercept=-LLfan.p2/LLfan.p1;
set(handles.frequency,'string',frequency);
set(handles.intercept,'string',intercept);
confidence1=str2double(get(handles.confidence1,'string'));
region1=confint(LLfan,confidence1/100);
set(handles.frequencylower,'string',1/region1(1,1));
set(handles.frequencyupper,'string',1/region1(2,1));
set(handles.interceptlower,'string',-region1(1,2)/LLfan.p1);
set(handles.interceptupper,'string',-region1(2,2)/LLfan.p1);
set(handles.result_F,'string',frequency);
set(handles.result_intercept,'string',intercept);
set(handles.result_BQ,'string',frequency/(1-intercept));
kF=sqrt(frequency*4*pi*e/h);
set(handles.result_kF,'string',kF*1e-10);
set(handles.result_area,'string',frequency*4*pi^2*e/(h*1e20));
npocket=kF^3/(3*pi^2);
set(handles.result_n1,'string',npocket*1e-6);

% save LL fan
if(get(handles.checkbox1,'value'))
    save_data=[plot_x,LLfan(plot_x)];
    save LLfan.txt save_data -ascii
end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% defining some useful constants
h=6.6260755e-34;
e=1.602176565e-19;
kB=1.3806505e-23;
me=9.10938215e-31;

% global parameters
global Bdata
global Adata
global Aerror
global flag_Dingle
global frequency
global intercept
global kF

[filename,filepath]=uigetfile('*.dat','打开文件');%gui中打开文件
filep=strcat(filepath,filename);
data2=importdata(filep);
[n,~]=size(data2);
Tdata=data2(:,1);
maxA=max(data2(:,2));
Adata2=data2(:,2)/maxA;
if get(handles.amplitudeerror2,'value')==2
    Aerror2=data2(:,3)/maxA;
else
    Aerror2=ones(n,1);
end
% Set up cyclotron mass fitting
ft = fittype( 'a*b*x/sinh(a*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0];
opts.StartPoint = [1 0.5];
opts.Upper = [10 Inf];
opts.Weights = 1./Aerror2;
% cyclotron mass fitting
mcfitting=fit(Tdata,Adata2,ft,opts);
axes(handles.axes2);
cla reset
hold on
plot_x=linspace(0,max(Tdata)+2,200)';
plot(plot_x,mcfitting(plot_x));
xlabel 'T (K)'
ylabel 'Amplitude (a.u.)'
if(get(handles.amplitudeerror2,'value')~=1)
    errorbar(Tdata,Adata2,Aerror2,'o')
else
    scatter(Tdata,Adata2,'o')
end
legend('fitting','data');
hold off

% save mcfitting
if(get(handles.checkbox2,'value'))
    save_data=[plot_x,mcfitting(plot_x)];
    save mcfitting.txt save_data -ascii
end

confidence2=str2double(get(handles.confidence2,'string'));
region2=confint(mcfitting,confidence2/100);
B2=str2double(get(handles.Bfor2,'string'));
global mc
mc = e*h*B2*(mcfitting.a)/(4*pi^3*kB*me);
mclower= e*h*B2*(region2(1,1))/(4*pi^3*kB*me);
mcupper=e*h*B2*(region2(2,1))/(4*pi^3*kB*me);
T3=str2double(get(handles.Tfor3,'string'));
j = 4*pi^3*kB*mc*T3*me/(e*h); % parameter for Dingle fitting
set(handles.mc,'string',mc);
set(handles.mclower,'string',mclower);
set(handles.mcupper,'string',mcupper);
set(handles.result_mc,'string',mc);
vF=h*kF/(2*pi*mc*me);
set(handles.result_vF,'string',vF*100);
EF=mc*me*vF^2;
set(handles.result_EF1,'string',EF/1.6e-22);
set(handles.result_EF2,'string',EF/3.2e-22);

if(flag_Dingle==1)
% perform Dingle fitting
dingledata=log(sinh(Bdata*j).*Adata./Bdata);
dinglefitting=fit(Bdata,dingledata,'poly1');
axes(handles.axes3);
cla reset
scatter(Bdata,dingledata,'.');
hold on
plot_x=[min(Bdata)/2,max(Bdata)+min(Bdata)]';
plot(plot_x,dinglefitting(plot_x));
xlabel '1/B (T^-^1)'
ylabel 'ln[△MR B sinh(λ(T))]'
legend("data","fitting");
hold off

% save Dingle fitting
if(get(handles.checkbox3,'value'))
    save_data=[plot_x,dinglefitting(plot_x)];
    save Dinglefit.txt save_data -ascii
    save_data=[Bdata,dingledata];
    save Dingledata.txt save_data -ascii
end

confidence3=str2double(get(handles.confidence3,'string'));
region3=confint(dinglefitting,confidence3/100);
set(handles.slope,'string',dinglefitting.p1);
set(handles.slopelower,'string',region3(1,1));
set(handles.slopeupper,'string',region3(2,1));
t=-mc*me*pi/(dinglefitting.p1*e); % quantum lifetime
set(handles.result_t,'string',t);
set(handles.result_l,'string',1e9*vF*t);
miu=e*t/(me*mc);
set(handles.result_miu,'string',miu*1e4);
end
rou=str2double(get(handles.rou,'string'));
set(handles.result_n2,'string',1e5*1e-6/(rou*e*miu));
end



% --- Executes on selection change in Bstyle.
function Bstyle_Callback(hObject, eventdata, handles)
% hObject    handle to Bstyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Bstyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Bstyle
end

% --- Executes during object creation, after setting all properties.
function Bstyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bstyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in amplitudedata.
function amplitudedata_Callback(hObject, eventdata, handles)
% hObject    handle to amplitudedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns amplitudedata contents as cell array
%        contents{get(hObject,'Value')} returns selected item from amplitudedata
end

% --- Executes during object creation, after setting all properties.
function amplitudedata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitudedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in errorBstyle.
function errorBstyle_Callback(hObject, eventdata, handles)
% hObject    handle to errorBstyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns errorBstyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from errorBstyle
end

% --- Executes during object creation, after setting all properties.
function errorBstyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorBstyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in amplitudeerror.
function amplitudeerror_Callback(hObject, eventdata, handles)
% hObject    handle to amplitudeerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns amplitudeerror contents as cell array
%        contents{get(hObject,'Value')} returns selected item from amplitudeerror
end

% --- Executes during object creation, after setting all properties.
function amplitudeerror_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitudeerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function Bfor2_Callback(hObject, eventdata, handles)
% hObject    handle to Bfor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bfor2 as text
%        str2double(get(hObject,'String')) returns contents of Bfor2 as a double
end

% --- Executes during object creation, after setting all properties.
function Bfor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bfor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function Tfor3_Callback(hObject, eventdata, handles)
% hObject    handle to Tfor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tfor3 as text
%        str2double(get(hObject,'String')) returns contents of Tfor3 as a double
end

% --- Executes during object creation, after setting all properties.
function Tfor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tfor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function rou_Callback(hObject, eventdata, handles)
% hObject    handle to rou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rou as text
%        str2double(get(hObject,'String')) returns contents of rou as a double
end

% --- Executes during object creation, after setting all properties.
function rou_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes during object creation, after setting all properties.
function Landaufan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Landaufan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end



function confidence1_Callback(hObject, eventdata, handles)
% hObject    handle to confidence1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of confidence1 as text
%        str2double(get(hObject,'String')) returns contents of confidence1 as a double

end
% --- Executes during object creation, after setting all properties.
function confidence1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confidence1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    set(hObject,'string',95);
end
end


% --- Executes on selection change in amplitudeerror2.
function amplitudeerror2_Callback(hObject, eventdata, handles)
% hObject    handle to amplitudeerror2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns amplitudeerror2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from amplitudeerror2

end
% --- Executes during object creation, after setting all properties.
function amplitudeerror2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitudeerror2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function confidence2_Callback(hObject, eventdata, handles)
% hObject    handle to confidence2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of confidence2 as text
%        str2double(get(hObject,'String')) returns contents of confidence2 as a double
end

% --- Executes during object creation, after setting all properties.
function confidence2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confidence2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function confidence3_Callback(hObject, eventdata, handles)
% hObject    handle to confidence3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of confidence3 as text
%        str2double(get(hObject,'String')) returns contents of confidence3 as a double
end

% --- Executes during object creation, after setting all properties.
function confidence3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confidence3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
