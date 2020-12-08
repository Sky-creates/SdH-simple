function j=k2coeff(k3,B,T)
%% K2COEFF gives the fitting coefficient calculted by the result of k3 fitting
%   j=k2coeff(k3,B,T)
%   B is the field where k3 is obtained;
%   T is the temperature where k2 is to be obtained;

% defining some useful constants
h=6.6260755e-34;
e=1.602176565e-19;
kB=1.3806505e-23;
me=9.10938215e-31;

m = e*h*B*k3/(4*pi^3*kB);
j = 4*pi^3*kB*m*T/(e*h);
fprintf('m*=%gme\nfitting coefficient=%g\n',m/me,j);
end