
%% Test File

%Parameters
ErrorsPerSigma = zeros(1,101);
s_maxTOT=zeros(1,101);
counter = 0;
N=128;

option=3;

synch=0; %number of bits off-synch

sigma=0.13;

%Test area

% for sigma = 0:0.001:1;
%     counter = counter +1; 
%     temp = zeros(1,100);
%     temp2 = zeros(1,100);
% for i=1:100

sigma2=0;

[z,z_p,bits,symbols]=transmitter(option);

% [y_hat,y_hat_p,sigma2] = channel(z,1,sigma);
 y_hat = simulate_audio_channel(z,sigma);
 
[b_hat,s_hat] = receiver(y_hat,option,synch);

s_max=max(abs(symbols-s_hat)); %This is a good measure, should be included 
                               %the report imo 

%scatterplot(s_hat)

BitErrors = 0;
for i=1:2*N
    if bits(i)~=b_hat(i)
        BitErrors=BitErrors+1;
    end
end
% temp(i) = BitErrors;
% temp2(i) = s_max;


% end
% ErrorsPerSigma(counter)=mean(temp(1:end));
% s_maxTOT(counter)=mean(temp2(1:end));
% end


disp(['The total number of bit errors are: ' int2str(BitErrors) char(10)...
    'The current noise level is: ' num2str(sigma2) 'dB' char(10)...
    'And the maximum differance between transmitted and received symbol is: ' num2str(s_max) char(10)])

%%
sigma = 0:0.001:1;
subplot(2,1,1)
plot(sigma,ErrorsPerSigma)
legend('Bit errors')
title('Bit errors vs Sigma (h_1 known to receiver)')
xlabel('Noise level')
ylabel('Bit errors')
xlim([0 0.1])
set(gca, 'fontsize',20)
subplot(2,1,2)
plot(sigma,s_maxTOT,'k*')
legend('Distance of ideal and estimated symbols')
xlabel('Noise level')
ylabel('Distance')
xlim([0 0.1])
set(gca, 'fontsize',20)



disp(['The total number of bit errors are: ' int2str(BitErrors) char(10)...
    'The current noise level is: ' num2str(sigma2) 'dB' char(10)...
    'And the maximum differance between transmitted and received symbol is: ' num2str(s_max) char(10)])



