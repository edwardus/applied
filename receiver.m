function [b_hat,s_hat] = receiver(y_rec,option,synch)
%{
Receives the signal after passing through the channel. Runs an energy
algorithm to detect the desired data. Thereafter the data is converted
back to baseband, sent through a decimation-filter, down-sampled.
Inverse-OFDM and equalization is used to estimate the transmitted symbols.
Lastly the symbols are converted back to bits.

Input: y_rec - The received signal.

       option - Flag parameter that can take three different values (1,2,3)
                for (1) and (2) the channel is known and the impusle
                response h1 and h2 is used respectively. 
                For (3) the channel is assumed to be unknown, and a pilot
                is therefore used to estimate the transfer function. 
       
       synch - Simulates a syncronization error.

Outputs: b_hat - The estimated bits. These are used for calculating the
                 BER.
 
         s_hat - The estimated symbols. Used to calculate the maximum
                 distance to the transmitted ideal symbols. 
                                                                    %}


%% Parameters
N = 128;
M = 80; %Length of prefix
R = 10; %Upsamplings-factor
D = 10; %Downsampling-factor

if option == 1
    h_len = 60; %Known length of impulse response
    b_hat = KnownChannel(y_rec,h_len); %Initiates a seperate and shorter
                                       %script for a known channel
    return;
    
    
elseif option == 2
    h_len = 9; %Known length of impulse response
    b_hat = KnownChannel(y_rec,h_len); %Initiates a seperate and shorter
                                       %script for a known channel
    return;
    
else
%% Parameters
    
QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);
s_pilot = QPSK(ones(1,N)); %The same pilot as have been transmitted
z_len = (N*2+160)+synch; %The length of the desired signal
z_len_up = z_len *R; %The length of the upsampled desired signal
h_len = length(y_rec)-z_len_up+1; %Length of the unknown impulse response
fs = 22050; %Sample frequency 
fc = 4000; %Carrier frequency
    
%% Detection algorithm (Energy based)

[~,index_start] = max(y_rec); %The index of the maximum peak
 
y_rec = y_rec(index_start-25:index_start+(M+2*N+1)*R); %The elements of 
                                                       %interest

% figure(3); plot(y_hat)
% title('shows our windowed signal')


%% Demodulation

n = ((0:length(y_rec)-1)/fs).';

y_base = y_rec.*exp(-1i*2*pi*fc*n); %The signal is converted back to
                                   %baseband

%% Decimation

B = firpm(32,2*[0 0.5/R*0.9 0.5/R*1.6 1/2],... %Lowpass-decimation filter, 
    [1 1 0 0]);                                %guards against aliasing
                                               %(when downsampling)
                                                       
y_dec = filter(B,1,y_base);

%% Down-sampling

y = downsample(y_dec,D); %The signal is down-sampled with a factor of 10

%% Inverse-OFDM
    
y_pilot = y(1:N); %Received pilot
    
y = y(N+M+1:N+M+N); % removal of the cyclic prefixes
    
r = fft(y); %length N
r_pilot = fft(y_pilot);

%% Equalizer
    
H_estimated  = r_pilot./s_pilot; %The channel is estimated using the 
                                 %received pilot and known pilot (length N)

s_hat=r./(H_estimated); %Estimated symbols
 
%% Inverse-QPSK

b_hat=zeros(1,2*N); %Temp vector
    
    for n=1:N
        b_hat((n*2-1))=sign(real(s_hat(n)));
        b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
    b_hat(b_hat==0)=3; %just for debugging
    b_hat(b_hat==-1)=0; %replace the -1 values
end
end

%% Code for plots



    



