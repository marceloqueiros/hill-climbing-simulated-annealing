%Primeiro trabalho Inteligência Artificial
%Ponto 4 - Multiple Re-start Hill Climbing
%Ponto 4 pede:
%       - considerar estagnação quando a solução 
%       corrente não se altera em 5 iterações

clc %limpar qualquer input ou output do minitor
clear %limpar variáveis
close all %apaga figuras anteriores

limits = [0,1.6] %limites da pesquisa
range= limits(2) - limits(1) %espaço de pesquisa

figure(1)%cria uma nova figura
set(0, 'defaultlinelinewidth', 3); %definir propriedades do gráfico
subplot(2,1,1); %divide a figura em graficos
ezplot('4*(sin(5*pi*x+0.5)^6)*exp(log2((x-0.8)^2))', [0,1.6]); %desenha a função
axis([0,1.6,-0.1,2]); %delimitar os eixos
title('Multiple Restart HC para Função:  4*(sin(5*pi*x+0.5)^6)*exp(log2((x-0.8)^2))')
xlabel('x');
ylabel('f(x)');
hold on %congelar gráficos existentes para os novos plots não apagarem os anteriores
 
x_radius=range/100; %raio de pesquisa

x_current=limits(1) + rand*range; %primeiro valor de x
                                  %rand devolve um valor entre 0 e 1
                                  %logo x_current = 0 + [0,1]*1.6
                                  %logo x_current = [0,1.6] <- pretendido

%chama função objetivo
F_current=4*(sin(5*pi*x_current+0.5)^6)*exp(log2((x_current-0.8)^2));

%a solução aproximada é: [0.066,1.6332]
%plot da solução
plot(0.066,1.6332, 'ok', 'markersize',6,'markerfacecolor', 'g');

%plot primeiro ponto
plot(x_current, F_current, '*k', 'markersize', 8);

%solução inicial
xplot(1)=x_current;
Fplot(1)=F_current;

xn(1:5)=0; %vetor para depois guardar os ultimos 5
FlagStag=0; %aumenta quando os ultimos 5 são iguais
nstag=1; %quando a FlagStag for igual a nstag é considerada estagnação 
jumps=0; %para contar numero de saltos
nmax=0; %para contar quantas vezes atinge o máximo

It=100;
for j=2:It,
    x_new = (x_current-x_radius)+rand*2*x_radius;   %calculo do novo X
    %subtrai raio e adiciona de 0 a 2*raio (dependendo do valor do rand)
    %logo x_new varia de [x_current-raio, x_current+raio]
    
    if(FlagStag==nstag)%se o contador de mudanças em 5 gor 0 salta
        x_new = limits(1) + rand*range; %calculo de novo x
        jumps=jumps+1; %incrementa saltos
        disp('Jump');  %para fazer display de Jump
    end
    %limitar procura no espaço de pesquisa
    if x_new < limits(1)
        x_new = limits(1);
    end
    if x_new > limits(2)
        x_new = limits(2);
    end
    
    %calculo da imagem de x
    F_new=4*(sin(5*pi*x_new+0.5)^6)*exp(log2((x_new-0.8)^2));
    
    if((nstag>FlagStag) && (F_new > F_current))  %ver se a nova imagem é melhor que a antigo
        x_current = x_new;
        F_current = F_new;
    elseif(FlagStag == nstag)   %caso seja um novo x tem de mudar o x_current também
        x_current = x_new;  
        F_current = F_new;
        %plot da nova solução inicial
        %plot(x_current,F_current, '*k');
        new_start_x(jumps)=x_new;  %para saber para onde saltou
        new_start_F(jumps)=F_new;  %para saber para que imagens saltou
        FlagStag=0;
    end
    
    %guardar valores em vetores para depois fazer plot
    xplot(j)=x_current;
    Fplot(j)=F_current;
    
    %calculo da media
    xn(5)=xn(4);
    xn(4)=xn(3);
    xn(3)=xn(2);
    xn(2)=xn(1);
    xn(1)=x_current;
    avg=(xn(5)+xn(4)+xn(3)+xn(2)+xn(1))/5;
    
    if (avg == x_current)%se a media for igual ao valor todos os 5 valores devem ser iguais
       	FlagStag=FlagStag+1;
        xn(1:5)=0; %reset ao vetor
        if(Fplot(j)>1.6)%a solução é aproximadamente acima de 1.6, logo acima de 1.6 considero que chegou ao máximo
            nmax=nmax+1; %pretendo saber quantas vezes atingiu o máximo
        end
        disp('Pesquisa estagnada');
    end
end
if(jumps>0)%fazer plot dos reinicios se houve saltos
    plot(new_start_x, new_start_F, '*g', 'markersize', 8);
end

%plot dos hill climbers
plot(xplot,Fplot,'or', 'Linewidth', 1, 'markersize', 8);

legend('f(x)', 'Máximo Global', 'Starting point','Re-start points','Hill Climbers', 'Location', 'North'); 
hold off

it = 1:1:It;

%x e f(x) do máximo global
F_ideal = 1.6332*ones(1,It);
x_ideal = 0.066*ones(1,It);

subplot(2,1,2);
axis([1,It,0,2]);%delimitação dos eixos
plot(it, F_ideal, 'b--', 'linewidth', 2);
hold on
plot(it, x_ideal,'g--','linewidth', 2)
plot(it, Fplot, 'r-', 'linewidth', 2);
plot(it, xplot,'k-', 'linewidth', 2);
legend('Máximo Global', 'X - Máximo', 'Máximo Atingido', 'X Atingido', 'Location', 'NorthEastOutside');
xlabel('Iterações');
ylabel('Valor');

axes('Position',[0 0 1 1],'Visible', 'off'); %grafico invisivel para escrever apenas
string = int2str(jumps);  %passar para string
string = strcat('Estagnou',{' '}, string, ' vezes;'); %juntar strings
text(0.7,0.2,string); %escrever

string = int2str(nmax);%passar para string
string = strcat('Chegou ao máximo',{' '}, string, ' vezes;'); %juntar strings
text(0.65,0.15,string); %escrever
hold off