function X_invsub = invsmosub(X)
%INVSMOSUB(X) inverts the odd rows of X and use Savizky-Golay smooth to subtract background. 
%   X should be n*2m dimension matrix
%   N specifies the order of polynomial fitting
%   The funciton is currently designed to perform with oscialltion of TaTe4
%   in 1-15 T

% increase precision
digits(64);
% specify number of data
s=[0 0];
s=size(X);
% invert first row
X_inv=zeros(s);
X_invsort=zeros(s);
for i=1:s(2)/2
    X_inv(:,2*i-1)=1./X(:,2*i-1);
    X_inv(:,2*i)=X(:,2*i);
    X_invsort(:,2*i-1:2*i)=sortrows(X_inv(:,2*i-1:2*i),1);
end
% use cubic spiline to interpolate
x=linspace(1/15,1,4*s(1))'; % 5 times more data to ensure compactness at high field
X_spi=zeros(length(x),s(2));
X_invsmo=zeros(length(x),s(2));
X_invsub=zeros(length(x),s(2));
for i=1:s(2)/2
    X_spi(:,2*i-1)=x;
    X_spi(:,2*i)=spline(X_inv(:,2*i-1),X_inv(:,2*i),x);   % cubic spline interpolate
    X_invsmo(:,2*i-1)=x;
    X_invsmo(:,2*i)=smooth(X_spi(:,2*i),s(1),'sgolay',5); % high span Savitzky-Golay smooth
    X_invsub(:,2*i-1)=x;
    X_invsub(:,2*i)=X_spi(:,2*i)-X_invsmo(:,2*i);
    figure
    plot(X_invsub(:,2*i-1),X_invsub(:,2*i));
    title(sprintf('oscillation of data #%1.0f',i))
    xlabel('1/B(1/T)')
    ylabel('¡÷R(a.u.)')
end
end

