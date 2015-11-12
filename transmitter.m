function out = transmitter()
%Transmitter file

%% Parameters
N = 128;
m= 2;
QPSK = [1+1i; 1-1i; -1+1i; -1-1i];

%% Script
bits = randsrc(1,2*N,[1 0]); %Random source of bits (length 2*N).

GroupBits = buffer(bits,m)'; %Here we group the bits 2 and 2.

codeword = bi2de(GroupBits,'left-msb')+1 %Assign each "group" to a decimal

symbols = QPSK(codeword);

OFDM = ifft(symbols,N);






out = [];

end

