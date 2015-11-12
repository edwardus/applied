
%% Test File
z=transmitter();

y_hat = channel(z);

y = receiver(y_hat);

