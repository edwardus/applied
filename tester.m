
%% Test File
z=transmitter();

y_hat = channel(z,2);



%y = receiver(y_hat);



%%
figure(1)
plot(z)

figure(2)
plot(real(y_hat))