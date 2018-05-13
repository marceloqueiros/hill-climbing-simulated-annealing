%Primeiro trabalho Inteligência Artificial
%Ponto 6 - Simulated Annealing função 3D

clc %limpar qualquer input ou output do minitor
clear %limpar variáveis
close all %apaga figuras anteriores

limits = [-2.048, 2.048;-2.048, 2.048] %limites da pesquisa
range= limits(2) - limits(1) %espaço de pesquisa

figure(1) %cria uma nova figura
colormap winter
ezcontourf('0.5+((sin(sqrt(x^2+y^2)))^2-0.5)/((1+0.001*(x^2+y^2))^2)',[-2.048,2.048],[-2.048,2.048]);
title('Simulated Annealing 3D');
hold on

Dim=2;
%primeira solução;
jj=1;
while (jj <= Dim) %varia de 1 a 2
    %Shubbert
    VarLBounds(jj)=-2.048;
    VarUBounds(jj)=+2.048;
    x(jj)=VarLBounds(jj)+rand(1)*(VarUBounds(jj)-VarLBounds(jj));
    jj=jj+1;
end
%plot primeira solução
plot(x(1),x(2), '*k', 'markersize', 8);

%chama função objetivo
F_current=0.5+((sin(sqrt(x(1)^2+x(2)^2)))^2-0.5)/((1+0.001*(x(1)^2+x(2)^2))^2);

MinBest=Inf; 
F_verybest=Inf;
x_verybest=x; %Melhor x
%MinBest----Melhor F
if(MinBest>F_current)
    MinBest=F_current;
end

T=50; %Temperatura Inicial = 50
Alpha=0.93; %para diminuir a temperatura
DeltaTeste=0.02;
It=100;
Rep_It=10;
nmrIt=1;
raio=0.1;
for n=1:It,
    for i=1:Rep_It,        
        x_new=x+raio*randn(1,2);
        
        if x_new(1) < VarLBounds(1)
            x_new(1) = VarLBounds(1);
        end
        if x_new(2) < VarLBounds(2)
            x_new(2) = VarLBounds(2);
        end
        if x_new(1) > VarUBounds(1)
            x_new(1) = VarUBounds(1);
        end
        if x_new(2) > VarUBounds(2)
            x_new(2) = VarUBounds(2);
        end
        
        F_new=0.5+((sin(sqrt(x_new(1)^2+x_new(2)^2)))^2-0.5)/((1+0.001*(x_new(1)^2+x_new(2)^2))^2);
        Delta=F_new-F_current;
        P=1/(1+exp(Delta/T)); %formula da probabilidade
        P_Real(nmrIt)=P;
        P_Ideal(nmrIt)=1/(1+exp(DeltaTeste/T));
        Vect_T(nmrIt)=T;
        % Se a nova solução for melhor que a atual
        if(Delta<=0)
            x=x_new;
            F_current=F_new;        
        elseif rand < P
                x=x_new;
                F_current=F_new;
                %pause(0.1);
        end
        
        if(F_current < F_verybest)
            F_verybest = F_current;
            x_verybest=x;
        end
        
        if(F_current < F_verybest)
            F_verybest = F_current;
            x_verybest = x;
        end
        
        plot(x_verybest(1), x_verybest(2), 'r*', 'Markersize',6,'LineWidth',2);
        nmrIt=nmrIt+1;
    end
    T=Alpha*T;
    disp(['x= ' num2str(x) ' fx= ' num2str(F_current) ' Temp= ' num2str(T)])
end

nmrIt=nmrIt-1;
it = 1:1:nmrIt;

figure(2)
subplot(2,1,1);
hold on
plot(it, P_Real, 'k-', 'linewidth', 1);
plot(it, P_Ideal, 'g-', 'linewidth', 1);
legend('Probabilidade Real', 'Probabilidade Ideal','Location', 'SouthWest');
title('Probabilidade real vs probabilidade ideal')
axis([400, nmrIt,0,1]);
xlabel('Iterações');
ylabel('Valor');
hold off
subplot(2,1,2);
hold on
plot(it, Vect_T, 'r-', 'linewidth', 1);
legend('Temperatura', 'Location', 'NorthEast');
title('Temperatura/Iterações')
xlabel('Iterações');
ylabel('Valor');
hold off

%figure(3)
%surf(peaks)