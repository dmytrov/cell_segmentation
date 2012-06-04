function varargout = NeuronDetectorUI(varargin)
% NEURONDETECTORUI MATLAB code for NeuronDetectorUI.fig
%      NEURONDETECTORUI, by itself, creates a new NEURONDETECTORUI or raises the existing
%      singleton*.
%
%      H = NEURONDETECTORUI returns the handle to a new NEURONDETECTORUI or the handle to
%      the existing singleton*.
%
%      NEURONDETECTORUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEURONDETECTORUI.M with the given input arguments.
%
%      NEURONDETECTORUI('Property','Value',...) creates a new NEURONDETECTORUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NeuronDetectorUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NeuronDetectorUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NeuronDetectorUI

% Last Modified by GUIDE v2.5 17-Nov-2011 23:10:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NeuronDetectorUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NeuronDetectorUI_OutputFcn, ...
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


% --- Executes just before NeuronDetectorUI is made visible.
function NeuronDetectorUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NeuronDetectorUI (see VARARGIN)

% Choose default command line output for NeuronDetectorUI
handles.output = hObject;

% Store image data
if (nargin > 4)
    handles.image = varargin{1};
    handles.restarg = varargin{2:end}; 
    nImages = size(handles.image, 3);
    set(handles.slider1, 'Value', 1, ...
                         'Min', 1, ...
                         'Max', nImages, ...
                         'SliderStep', [1/(nImages), 1/(nImages)]);
    %set(handles.axesImg, 'Position.width', size(handles.image, 2), ...
    %                     'Position.height', size(handles.image, 1));
    [handles] = PresentImage(handles.slider1, handles);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NeuronDetectorUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = NeuronDetectorUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles] = PresentImage(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Update handles structure
guidata(hObject, handles);

function [res] = PresentImage(hSlider, handles)
imgIndex = floor(get(hSlider,'Value')); 
set(handles.textImgIndex, 'String', num2str(imgIndex));
axes(handles.axesImg);
imshow(handles.image(:,:,imgIndex), handles.restarg);
res = handles;

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
