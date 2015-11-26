function b_hat = KnownChannel(y_hat)

%% Processing
m=2;
N=128;
known = 0;
M=80;
R=10;

    y_hat = y_hat(h_len+1:h_len+N); % removal of the cyclic prefix and delay
    
    r=fft(y_hat);
    
    H = fft(h,N); % The transfer function H(w)
    % scatterplot(r)
    % title('Scatterplot of r - i.e s affected by the channel')
    
    s_hat=r./(conj(H))';
    
    
    % scatterplot(s_hat)
    % title('Scatterplot of received symbols - noisy')
    
    b_hat=zeros(1,2*N);
    for n=1:N
        b_hat((n*2-1))=sign(real(s_hat(n)));
        b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
    b_hat(b_hat==0)=3; %just for debugging
    b_hat(b_hat==-1)=0; %replace the -1 values

end