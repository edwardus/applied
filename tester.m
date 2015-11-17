
%% Test File
[z,ofdm,bits]=transmitter();


[y_hat,h] = channel(z,1);




b_hat = receiver(y_hat,h);




%%
figure(1)
subplot(2,1,1)
plot(b_hat)

subplot(2,1,2)
plot(bits)

