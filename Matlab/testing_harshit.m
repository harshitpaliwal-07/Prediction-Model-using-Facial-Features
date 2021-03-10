function varargout = testing_vedant(varargin)
% TESTING_VEDANT MATLAB code for testing_vedant.fig
%      TESTING_VEDANT, by itself, creates a new TESTING_VEDANT or raises the existing
%      singleton*.
%
%      H = TESTING_VEDANT returns the handle to a new TESTING_VEDANT or the handle to
%      the existing singleton*.
%
%      TESTING_VEDANT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTING_VEDANT.M with the given input arguments.
%
%      TESTING_VEDANT('Property','Value',...) creates a new TESTING_VEDANT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testing_vedant_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testing_vedant_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testing_vedant

% Last Modified by GUIDE v2.5 03-Oct-2018 18:14:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testing_vedant_OpeningFcn, ...
                   'gui_OutputFcn',  @testing_vedant_OutputFcn, ...
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


% --- Executes just before testing_vedant is made visible.
function testing_vedant_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testing_vedant (see VARARGIN)

% Choose default command line output for testing_vedant
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testing_vedant wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testing_vedant_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('hello vedant')