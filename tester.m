
%% Test File
[z,ofdm,GroupBits]=transmitter();

[y_hat,h,y_len] = channel(z,1);



y = receiver(y_hat,h,y_len);



%%
figure(1)
subplot(2,1,1)
plot(real(ofdm)*-1)

subplot(2,1,2)
plot(real(y))
%%
scatter(ofdm*-1,'r')
