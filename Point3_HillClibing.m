%Primeiro trabalho Intelig�ncia Artificial
%Ponto 3 - Hill Climbing Normal
%Ponto 3 pede:
%       - 100 itera��es por teste
%       - Raio de pesquisa 0.01

clc %limpar qualquer input ou output do minitor
clear %limpar vari�veis
close all %apaga figuras anteriores

limits = [0,1.6] %limites da pesquisa
range= limits(2) - limits(1) %espa�o de pesquisa

figure(1)%cria uma nova figura
set(0, 'defaultlinelinewidth', 3); %definir propriedades do gr�fico
subplot(2,1,1); %divide a figura em graficos
ezplot('4*(sin(5*pi*x+0.5)^6)*exp(log2((x-0.8)^2))', [0,1.6]); %desenha a fun��o
axis([0,1.6,-0.1,2]); %delimitar os eixos
title('Hill Climbing para Fun��o:  4*(sin(5*pi*x+0.5)^6)*exp(log2((x-0.8)^2))')
xlabel('x');
ylabel('f(x)');
hold on %congelar gr�ficos existentes para os novos plots n�o apagarem os anteriores
 
x_radius=range/100; %raio de pesquisa

x_current=limits(1) + rand*range; %primeiro valor de x
                                  %rand devolve um valor entre 0 e 1
                                  %logo x_current = 0 + [0,1]*1.6
                                  %logo x_current = [0,1.6] <- pretendido

%chama fun��o objetivo
F_current=4*(sin(5*pi*x_current+0.5)^6)*exp(log2((x_current-0.8)^2));

%a solu��o aproximada �: [0.066,1.6332]
%plot da solu��o
plot(0.066,1.6332, 'ok', 'markersize',6,'markerfacecolor', 'g');

%plot primeiro ponto
plot(x_current, F_current, '*k', 'markersize', 8);

%solu��o inicial
xplot(1)=x_current;
Fplot(1)=F_current;

It=100;

for j=2:It,
    x_new= (x_current-x_radius)+rand*2*x_radius   %calculo do novo X
    %subtrai raio e adiciona de 0 a 2*raio (dependendo do valor do rand)
    %logo x_new varia de [x_current-raio, x_current+raio]
    
    %limitar procura no espa�o de pesquisa
    if x_new < limits(1)
        x_new = limits(1);
    end
    if x_new > limits(2)
        x_new = limits(2);
    end
    
    %calculo da imagem de x
    F_new=4*(sin(5*pi*x_new+0.5)^6)*exp(log2((x_new-0.8)^2));
    
    %ver se a nova imagem � melhor que a antigo
    if(F_new > F_current)
        x_current = x_new;
        F_current = F_new;
    end
    
    %guardar valores em vetores para depois fazer plot
    xplot(j)=x_current;
    Fplot(j)=F_current;
end

%plot dos hill climbers
plot(xplot,Fplot,'or', 'Linewidth', 2, 'markersize', 8);

legend('f(x)', 'M�ximo Global', 'Starting point','Hill Climbers', 'Location', 'North');  
hold off

it = 1:1:It;

%x e f(x) do m�ximo global
F_ideal = 1.6332*ones(1,It);
x_ideal = 0.066*ones(1,It);

subplot(2,1,2);
axis([1,It,0,2]);%delimita��o dos eixos
plot(it, F_ideal, 'b--', 'linewidth', 2);
hold on
plot(it, x_ideal,'g--','linewidth', 2)
plot(it, Fplot, 'r-', 'linewidth', 2);
plot(it, xplot,'k-', 'linewidth', 2);
legend('M�ximo Global', 'X - M�ximo', 'M�ximo Atingido', 'X Atingido', 'Location', 'NorthEastOutside');
xlabel('Itera��es');
ylabel('Valor');
hold off