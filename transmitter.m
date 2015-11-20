function [z,z_p,bits,symbols] = transmitter(fall)

%Transmitter file

%% Parameters
N = 128;
m= 2;
z_p=[];
QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);
 s_pilot= QPSK(repmat([1:4],1,32));

if fall == 1
M=60; %Length of the cyclic prefix, i.e length of h1
end
if fall == 2
M=9; %Length of the cyclic prefix, i.e length of h2
end
if fall == 3
% M=N*2; %Length of the cyclic prefix, i.e length of hx
M=N; %Detta är längden på det vi vill skicka (exklusive prefix)
end

%% Script
bits = randsrc(1,2*N,[1 0]); %Random source of bits (length 2*N).

GroupBits = buffer(bits,m)'; %Here we group the bits 2 and 2.

codeword = bi2de(GroupBits,'left-msb')+1; %Assign each "group" to a decimal.

symbols = QPSK(codeword); %Each number is assigned to our constellation.
figure(5)
scatterplot(symbols)
title('Scatterplot of transmitted symbols')
if fall == 3
OFDM_p=ifft(s_pilot);
Prefix_s=OFDM_p;
z_p=[OFDM_p;OFDM_p]
end

OFDM = ifft(symbols); %We apply inverse-fft on our symbols (OFDM).


Prefix = OFDM((end-M+1):end); %Cyclic prefix: Gimics a infinite time-signal
                              %and works as a guard intervall.
                              
z = [Prefix;OFDM]; % adds the prefix to the signal.

% figure(1)
% plot(real(z))
% title('Transmitted signal')
end

