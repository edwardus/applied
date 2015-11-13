
%% Test File
[z,ofdm]=transmitter();

[y_hat,h] = channel(z,1);



y = receiver(y_hat,h);



%%
figure(1)
subplot(2,1,1)
plot(real(ofdm))

subplot(2,1,2)
plot(real(y))
