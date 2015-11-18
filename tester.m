
%% Test File
N=128;
[z,ofdm,bits,symbols]=transmitter();


[y_hat,h,y_len] = channel(z,1);




[b_hat,s_hat] = receiver(y_hat,h,y_len);
s_max=max(abs(symbols-s_hat))
BitErrors = 0;
for i=1:2*N
    if bits(i)~=b_hat(i)
        BitErrors=BitErrors+1;
    end
end
BitErrors

%%
figure(1)
subplot(2,1,1)
plot(b_hat)

subplot(2,1,2)
plot(bits)

