function [z_mr,bits,symbols] = transmitter(option)

%{
Takes a set of bits and modulates them to QPSK symbols, thereafter the
OFDM is calculated and a cyclic-prefix is added for both the pilot and the
data packet. The signal is then upsampled with a factor of R = 10 and
interpolated. Thereafter, the signal is modulated with carry frequency fc
and finally outputed as soundwaves. 

Input: Option - Flag parameter that can take three different values (1,2,3)
                for (1) and (2) the channel is known and the impusle
                response h1 and h2 is used respectively. 
                For (3) the channel is assumed to be unknown, and a pilot
                is therefore used to estimate the transfer function. 

Outputs: z_mr - The real part of the modulated signal. It is zmr that is 
                transmitted as soundwaves.
 
         bits - The randomly generated bits. These are set as an output as
                we are interested to calculate the BER.

         symbols - The generated QPSK symbols. Used to calculate the 
                   maximum distance to the estimated symbols in the Rx.
                                                                        %}
%%
if nargin<1 
    error('Input an integer (1,2,3) to select channel property, (3) equals unknown channel');
end

%% Parameters
N = 128;
m = 2; %m = log2(M), where M is the cardinality of our alphabet
fs = 22050; %Desired sampling frequency
fc = 4000; %Carrier frequency
R = 10; %Upsampling-factor

QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2); 
s_pilot= QPSK(ones(1,N)); %The pilot constist of N QPSK symbols
 
if option == 1
    M=60; %Length of the cyclic prefix, i.e length of h1
    Prefix_p = [];
    OFDM_p = [];
elseif option == 2
    M=9; %Length of the cyclic prefix, i.e length of h2
    Prefix_p = [];
    OFDM_p = [];
else %This is used when the channel is unknown, here we create a pilot
     %to estimate the channel
    M=80;
    OFDM_p = ifft(s_pilot);
    Prefix_p = OFDM_p((end-M+1):end);
end

%% Script
bits = randsrc(1,2*N,[1 0]); %Random source of bits (length 2*N)

GroupBits = buffer(bits,m)'; %Here we group the bits 2 and 2

codeword = bi2de(GroupBits,'left-msb')+1; %Assign each "group" to a decimal

symbols = QPSK(codeword); %Each number is assigned to our constellation

OFDM = ifft(symbols); %We apply inverse-fft on our symbols (OFDM).

Prefix = OFDM((end-M+1):end); %Cyclic prefix: Gimics a infinite time-signal
                              %and works as a guard intervall.
                              
z = [Prefix_p;OFDM_p;Prefix;OFDM]; %adds pilot and both prefixes to the
                                   %signal.

%% Upsampling

z_u = upsample(z,R); %Upsampled signal

%% Interpolation
%By lowpass filtering the signal, we interpolate the zeros caused by the
%upsampling

B = firpm(32,2*[0 0.5/R*0.9 0.5/R*1.6 1/2],[1 1 0 0]); %lowpass filter

z_i = filter(B,1,z_u); %Interpolated signal

%% Modulation

n = ((0:length(z_i)-1)/fs).'; 

z_mr = real(z_i.*exp(1i*2*pi*fc*n)); %  mr = 'modulated real'

z_mr = z_mr/max(z_mr); % The signal is normalized to avoid clipping

sound(z_mr,fs) %The signal is transmitted as soundwaves

end

%% Code for plots

% Plot fft of the upsampled signal
% figure(1)
% plot(real(zu))
% semilogy(f,abs(fft(zu,NN))) % Check transform
% xlabel('normalized frequency f/fs');
