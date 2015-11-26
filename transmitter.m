function [zmr,z_p,bits,symbols] = transmitter(option)

%Transmitter file

%% Parameters
N = 128;
m= 2;
fs = 22050;
fc = 4000;

z_p=[];
QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2); 
 s_pilot= QPSK(repmat(1,1,N))
 %% testing
%  bits_p = randsrc(1,2*N,[1 0]);
%  
% GroupBits_p = buffer(bits_p,m)'; %Here we group the bits 2 and 2.
% 
% codeword_p = bi2de(GroupBits_p,'left-msb')+1; %Assign each "group" to a decimal.
% 
% s_pilot = QPSK(codeword_p); %Each number is assigned to our constellation.
 
 %%
 
if option == 1
M=60; %Length of the cyclic prefix, i.e length of h1
end
if option == 2
M=9; %Length of the cyclic prefix, i.e length of h2
end
if option == 3 %This is used when the channel is unknown
% M=N*2; %Length of the cyclic prefix, i.e length of hx
M=80; %This is the length of the packet we want to send (exclusive the prefix)
end

%% Script
bits = randsrc(1,2*N,[0 1]); %Random source of bits (length 2*N).

GroupBits = buffer(bits,m)'; %Here we group the bits 2 and 2.

codeword = bi2de(GroupBits,'left-msb')+1; %Assign each "group" to a decimal.

symbols = QPSK(codeword); %Each number is assigned to our constellation.
% figure(5)
% scatterplot(symbols)
% title('Scatterplot of transmitted symbols')
if option == 3
OFDM_p=ifft(s_pilot);
Prefix_p = OFDM_p((end-M+1):end);

end

OFDM = ifft(symbols); %We apply inverse-fft on our symbols (OFDM).


Prefix = OFDM((end-M+1):end); %Cyclic prefix: Gimics a infinite time-signal
                              %and works as a guard intervall.
                              

z = [Prefix_p;OFDM_p;Prefix;OFDM]; % adds the prefix to the signal.
% 
% figure(83)
% plot(real(z))
% 
% Fs=2205;
% % 
% Y = fft(z);
% L=length(z);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% f = Fs*(0:(L)/2)/L;
% figure(9)
% plot(f,P1)
% title('Single-Sided Amplitude Spectrum of Z')
% xlabel('f (Hz)')
% ylabel('|z(f)|')
% xlim([0 13000])
% 
% 


% Works until here
%%
NN = 2^14; % Number of frequency grid points
f = (0:NN-1)/NN;

R=5;
zu = zeros(length(z)*R,1);
zu(1:R:end) = z;

% figure(24)
% plot(real(zu))
% semilogy(f,abs(fft(zu,NN))) % Check transform
% xlabel('normalized frequency f/fs');


%%

B = firpm(32,2*[0 0.5/R*0.9 0.5/R*1.6 1/2],[1 1 0 0]);

zi = filter(B,1,zu);

n = ((0:length(zi)-1)/fs).';

zmr = real(zi.*exp(1i*2*pi*fc*n));
 

zmr = zmr/max(zmr);


sound(zmr,fs)

end

