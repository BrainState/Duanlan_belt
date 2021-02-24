% Initialize NI run in Matlab-64 bit 
% @ Session-Based Interface
% By Zeng Huanhuan @ 27-Mar-2019
%% Initialize
s = daq.createSession('ni');
% warning off
addDigitalChannel(s,'J1', 'Port0/Line0:1', 'OutputOnly');
outputSingleScan(s,[0 0]);
stop(s);
delete(s);
% close all;clc;clear all
%% DIO
AI = daq.createSession('ni');%%%%%%%%%%%%%% Analog input
stop(AI);
delete(AI);
clear AI s
%%
%     AI = daq.createSession('ni');%%%%%%%%%%%%%% Analog input
%     addAnalogInputChannel(AI,'Dev2', 0:3, 'Voltage');% Analog input Channel [0:3];For frame time and stimulus trigger
%     AI.Rate = 5000;% Analog input sample rate
%     AI.DurationInSeconds = 10;% Analog sample time
%     global data
%     lh = addlistener(AI,'DataAvailable', @plotData);
%     startBackground(AI);
