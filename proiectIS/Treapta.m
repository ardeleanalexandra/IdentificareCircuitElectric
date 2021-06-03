%Rasp la treapta
t=scope24{:,1};
u=scope24{:,2};
y=scope24{:,3};

plot(t,[u,y]) 
title('Raspunsul sistemului de ordin II la semnal de tip treapta'), grid;
legend('semnal treapta','raspunsul sistemului');

%i1=438;
%i2=489;
%i3=901;
%i4=961;

y0=mean(y(i1:i2))
u0=mean(u(i1:i2))
yst=mean(y(i3:i4))
ust=mean(u(i3:i4))

%calcul factor de proportionalitate 
k=(yst-y0)/(ust-u0)
 hold on

figure
plot(t,yst*ones(1,length(t)),'--');
hold on
plot(t,[u,y],t,yst*ones(length(y)),'--')

i5=505
i6=607
%Calcul suprareglaj
sigma=(y(i6)-yst)/(yst-y0)

%Calcul factor de amortizare
zeta = -log(sigma)/(sqrt(pi*pi+log(sigma)*log(sigma)))
T_osc=2*(t(i6)-t(i5))
 
% Pulsatia oscilatiilor amortizate
w_osc=2*pi/T_osc
 
% Pulsatia naturala a oscilatiilor neamortizate
wn = w_osc/sqrt(1-zeta^2)

%fct tranf
H=tf(k*wn^2,[1,2*zeta*wn,wn^2])
%cond nenule
A=[0 1 ; -wn^2 -2*zeta*wn]
B=[0; k*wn^2]
C=[1 0];
D=0;

ysim_tr = lsim(A,B,C,D,u,t,[y(1), 0])
figure
plot(t,[u y ysim_tr])
title('Raspunsul la treapta') 
xlabel('t (sec)')
ylabel('u(V),y(V)')
J= sqrt(1/1000*sum((y-ysim_tr).^2)); 
e=norm(y-ysim_tr)/norm(y-mean(y))



%impuls-treapta
ysim_im=lsim(A1,B1,C,D,u,t,[y(1),0]);
hold on
plot(t,[u y ysim_tr ysim_im])
title('Raspunsul la treapta')
xlabel('t (sec)')
ylabel('u(V),y(V)')
 
eroarea_treapta=norm(y-ysim_im)/norm(y-mean(y))
J_impuls=norm(y-ysim_im)/sqrt(1000)


