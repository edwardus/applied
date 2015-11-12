<<<<<<< HEAD
%% Transmitter
%% Create bit stream

b= %bitstream (k)
%% QPSK

s= %symbols (k)
%% OFDM

z=
%% Send through channel
=======
function out = transmitter()
%Transmitter file

%% Parameters
N = 128;
m= 2;


%% Script
bits = randsrc(1,2*N,[1 0]); %Random source of bits (length 2*N).

GroupBits = buffer(bits,m)'; %Here we group the bits 2 and 2.

codeword = bi2de(GroupBits,'left-msb')+1; %Assign each "group" to a decimal




out = [];

end
>>>>>>> 6ec99dc9b15b04b7152157e4534af43c565e8577

