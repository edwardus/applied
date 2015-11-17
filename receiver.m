function b_hat = receiver(y_hat,h)
%% Parameters
m=2;
N=128;
M=60; %Make sure we use the same L in transmitter and receiver

<<<<<<< HEAD
%% Processing
y_hat = y_hat((M+1):end); % removal of the cyclic prefix
y_hatl=length(y_hat)
y_hat = y_hat(1:(end-(M-1)));
y_hatl=length(y_hat)
h_hat = fft(h,N);
y_hatl=length(y_hat)
r=fft(y_hat);
rl=length(r)
s_hat=r.*conj(h_hat)';
b_hat=zeros(1,256)
for n=1:128
    b_hat((n*2-1))=sign(real(s_hat(n)));
    b_hat((n*2))=sign(imag(s_hat(n)));
end


