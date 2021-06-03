%Rasp la impuls
t1=scope23{:,1}; %timpul
u1=scope23{:,2}; %intrarea
y1=scope23{:,3}; %iesirea

plot(t1,[u1,y1]);
title('Date exp. la identificarea pe baza de intrare de tip impuls')
xlabel('t (sec)')
ylabel('u(V),y(V)'), grid

i1=386;
i2=468;

ust1=mean(u1(i1:i2)) %media dintre cele 2 val ale regimului stationar
yst1=mean(y1(i1:i2 )) %unde e stationar
hold on 
figure
plot(t1,yst1*ones(length(t1)),'r')

%factorul de proportionalitate
K=yst1/ust1

%suprareglajul
i3=510;
i4=609;
i5=710;
 
DT = t1(2)-t1(1);
Aminus = sum(abs(yst1-y1(i4:i5))*DT)
Aplus = sum(abs(yst1-y1(i3:i4))*DT)
sigma1 = Aminus/Aplus

%Fact amortizare
zeta1=-log(sigma1)/sqrt(pi*pi+log(sigma1)*log(sigma1))

%Per osc
i6=546;
i7=649;
Tosc1=2*(t1(i7)-t1(i6))
wosc1=2*pi/Tosc1

%Pulsatie naturala
wn1=wosc1/sqrt(1-zeta1*zeta1)


%Functia de transfer
H1=tf(K*wn1^2,[1 2*zeta1*wn1 wn1^2])

% Conditii nule
A1=[0 1;-wn1*wn1 -2*(zeta1*wn1)]
B1=[0;K*wn1*wn1]
C1=[1 0]
D1=0;


ysim_im=lsim(A1,B1,C1,D1,u1,t1,[y1(1) 0]);
 
figure
plot(t1,[u1 y1 ysim_im]), grid
title('Raspunsul la impuls') 
xlabel('t (sec)')
ylabel('u(V),y(V)')
% 
J1=norm(y1-ysim_im) %eroare medie patratica
E1=norm(y1-ysim_im)/norm(y1-mean(y1)) %eroare medie patratica normalizata



%treapta-impuls
ysim_tr=lsim(A,B,C,D,u1,t1,[y1(1),0]);

figure
plot(t1,[u1 y1 ysim_im ysim_tr]) ,grid
title('Raspunsul la impuls');
xlabel('t (sec)')
ylabel('u(V),y(V)')
 
eroarea_impuls=norm(y1-ysim_tr)/norm(mean(y1))
J_treapta=norm(y1-ysim_tr)/sqrt(1000)






 