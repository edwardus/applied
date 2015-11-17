function [z,OFDM,bits] = transmitter()

%Transmitter file

%% Parameters
N = 128;
m= 2;
M=60; %Length of the cyclic prefix
QPSK = [1+1i; 1-1i; -1+1i; -1-1i]./sqrt(2);

%% Script
bits = randsrc(1,2*N,[1 0]); %Random source of bits (length 2*N).

GroupBits = buffer(bits,m)'; %Here we group the bits 2 and 2.

codeword = bi2de(GroupBits,'left-msb')+1; %Assign each "group" to a decimal.

symbols = QPSK(codeword); %Each number is assigned to our constellation.


OFDM = ifft(symbols); %We apply inverse-fft on our symbols (OFDM).

Prefix = OFDM((end-M+1):end); %Cyclic prefix: Gimics a infinite time-signal
       length(Prefix)                    %and works as a guard intervall.

z = [Prefix;OFDM]; % adds the prefix to the signal.

z =real(z);
z= z./max(z);


end

