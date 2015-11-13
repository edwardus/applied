function y = receiver(y_hat,h)

%% Parameters
m=2
N=128;
M=128; %Make sure we use the same L in transmitter and receiver

%% Processing
y_hat = y_hat(M:end); % removal of the cyclic prefix
y_hat = y_hat(1:end-M);
h_hat = fft(h,N);
y_hat=fft(y_hat,N);
x=ifft(y_hat./h_hat',N);
y=x;



%% Demodulation

%% Decimals to bits

%bits = de2bi(symbols, m, 'left-msb');




end


