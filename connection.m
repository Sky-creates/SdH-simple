function [sF,kF,vF,EF,m,t,l,mob,n]=connection(k1,k2,k3,B,rou)
%% CONNECTION uses several fitted data in SdH oscillation to calculate parameters, with function defined as [kF,vF,m,t,l,mob,n]=connection(k1,k2,k3,B,rou)
%	k1 is the slope of n(#LL)-1/B linear fitting;
%	k2 is the slope of Dingle fitting;
%	k3 is the parameter in nonlinear fitting k3T/sinh(k3T) with respect to
%	temperature; B is the magnetic field under which k3 is obtained;
%	rou is the electrical resistivity, and should be specified at the same temperature with k2 under zero magnetic field;
%   all quantities should be specified under SI units

% defining some useful constants
h=6.6260755e-34;
e=1.602176565e-19;
kB=1.3806505e-23;
me=9.10938215e-31;

sF=k1;
kF=sqrt(k1*4*pi*e/h);
m=e*h*k3*B/(4*pi^3*kB);
t=-m*pi/(k2*e);
vF=h*kF/(2*pi*m);
EF=m*vF^2;
l=vF*t;
mob=e*t/m;
n=1/(rou*e*mob);

fprintf('calculated result:\n sF=%g(T)\n kF=%d(cm^-1)\n vF=%g(cm/s)\n EF=%gmeV\n m*=%gme\n t=%g(s)\n l=%g(nm)\n mob=%g(cm^2/(Vs)\n n=%g(cm^-3))',sF,kF/100,100*vF,1000*EF/e,m/me,t,l*10^9,mob*10^4,n/10^6);

end


