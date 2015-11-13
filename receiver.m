function y = receiver(y_hat)
N=128;
L=128; %Make sure we use the same L in transmitter and receiver
y_hat=y_hat(L:end) % removal of the cyclic prefix

y=fft(y_hat,N);






end


