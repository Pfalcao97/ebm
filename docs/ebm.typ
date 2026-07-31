#import "@preview/abntyp:0.1.5": *

#set page(
  paper: "us-letter",
  header: align(right)[
    Do Cálculo à Simulação Numérica
  ],
  numbering: "1",
)
#set par(justify: true)
#set text(
  font: "Libertinus Serif",
  size: 11pt,
)
#set text(lang: "pt", region: "BR")



#show title: set text(size: 17pt)
#show title: set align(center)
#show math.equation: set block(breakable: true)

#title[
  Modelagem Numérica para um Modelo Climático de Balanço de Energia
]


#align(center)[
  Pedro Falcão 
]


= Introdução

As ciências climáticas já se utilizam dos métodos numéricos há muito tempo. Desde quando, inclusive, esses métodos eram realizados ainda em máquinas eletromecânicas.

Hoje, mais do que nunca, nós dependemos desses métodos numéricos aplicados à climatologia: seja para prever o clima na semana seguinte, seja para nos precaver de possíveis catastrofes e nos preparar para situações adversas.

Essa dependência surge, não só por conta da disponibilidade dessas ferramentas, mas também, pela maior incidência de eventos extremos gerados pelas mudanças climáticas. @glossary-ipcc

Possivelmente, este será o ano mais quente já registrado na história, por larga margem. As evidências se acumulam de que este será um ano de "El Niño" mais forte do que jamais foi visto @zeke.

#figure(
  image("imgs/elnino.png", width: 70%),
  caption: [
    Previsões do aquecimento do Oceano Pacífico no próximo evento de El Niño, previsto para o final deste ano, feitas por vários modelos. Fonte: @zeke.
  ],
) <elnino>

A @elnino mostra justamente como dados experimentais podem ser usados, junto de modelos numéricos, para extrapolar possíveis cenários futuros.

Pela importância desse tema, principalmente na situação atual, escolhi desenvolver um modelo climático simples, para aprofundar meu entendimento dessa área do conhecimento.

= Fundamentação Teórica

Em um Modelo de Balanço de Energia (EBM), estamos sempre tentando equacionar a variação de energia no sistema terrestre. Isso significa considerar as entradas, principalmente a radiação solar, as saídas, principalmente a radiação da Terra, e os diversos mecanismos de Feedback internos às dinâmicas do planeta para entender a variação da temperatura.

#figure(
  image("imgs/trenberth.png", width: 70%),
  caption: [
    Diagrama de balanço de energia do sistema. Fonte: @trenberth.
  ],
) <trenberth-img>

A @trenberth-img traz um diagrama simplificado com alguns dos principais fluxos de energia do nosso planeta. Vale destacar que:

- Existe uma única entrada de energia no sistema, a radiação solar.
- Existem duas saídas de energia do sistema:
  - Uma saída "rápida", que é a luz refletida na superfície ou nas nuvens.
  - Uma saída "atrasada", que é a radiação emitida pela atmosfera.

Um EBM simples, como o descrito em @stocker, apresenta um equacionamento justamente dessas três características fundamentais. Trata-se de um modelo geométrico simplificado, chamado pelo próprio autor como "um modelo do balanço de radiação em um ponto" (_Point model of the radiation balance_). Nesse modelo, a Terra recebe radiação, com intensidade $S_0$, de maneira perpendicular em uma seção transversal na forma de disco com raio $R$, uma fração ($alpha$) da qual é refletida diretamente. Ela então emite radiação de forma radial (uma esfera) como um corpo negro.

#figure(
  image("imgs/modelo.png", width: 70%),
  caption: [
    Representação do modelo de balanço de radiação em um ponto. Fonte: Próprio Autor.
  ],
) <modelo>

O balanço de energia e, portanto, a variação de temperatura ao longo do tempo, $T(t)$, é feito em uma camada de ar atmosférico com altura $h$, densidade $rho$ e calor específico $c$. Matematicamente, temos:

$ 4 pi R^2 h rho c (d T(t))/(d t) = pi  R^2 (1 − alpha) S_0 − 4 pi R^2 epsilon sigma T(t)^4  $

Adicionalmente, podemos ainda considerar o forçamento radiativo, que é definido pelo @glossary-ipcc como uma mudança na diferença entre a radiação que entra menos a radiação que sai, expressa em $W m^(-2)$, causado por uma alteração em algum causador de mudanças climáticas, como a concentração de gases do efeito estufa na atmosfera ou a presença de aerosols vulcânicos.

@forcing apresenta uma equação analítica para aproximar os efeitos de forçamento radiativo dos três principais gases do efeito estufa, Gás Carbônico, $"CO"_2$; Óxido Nitroso, $"N"_2"O"$; e Metano, $"CH"_4$. Por conta de uma sobreposição nas faixas de frequência de luz que os gases absorvem, as equações têm parâmetros mistos, ou seja, o forçamento radiativo do gás carbônico não depende apenas da concentração desste, mas também de outros gases estudados. Por exemplo, o forçamento radiativo do gás carbônico é dado por:

$ R_(C O_2) = [a_1 (C - C_0)^2 + b_1 |C - C_0| + c_1 dash(N) + 5.36] ln(C/(C_0)) $

Onde $a_1$, $b_1$ e $c_1$ são coeficientes obtidos durante a análise dos dados experimentais e têm valores, respectivamente,  $-2.4×10^(-7) W m^(-2)"ppm"^(-1)$, $7.2×10^(-4) W m^(-2)"ppm"^(-1)$ e $−2.1×10^(-4) W m^(-2)"ppm"^(-1)$. $C$ é a concentração atual de gás carbônico, em partes por milhão (ppm), $C_0$ é a concentração inicial e $dash(N)$ é a média da concentração de óxido nitroso, dado por:

$ dash(N) = 0.5(N_0 + N) $

Onde, $N$ é, também, a concentração atual e $N_0$ a concentração inicial.

Juntando todas as partes, chegamos a uma equação capaz de modelar o impacto dos gases de efeito estufa na temperatura da Terra:

$ 4 pi R^2 h rho c (d T(t))/(d t) = pi  R^2 (1 − alpha) S_0 − 4 pi R^2 epsilon sigma T(t)^4 \ + [a_1 (C - C_0)^2 + b_1 |C - C_0| + c_1 dash(N) + 5.36] ln(C/(C_0)) $

Embora algumas constantes sejam hipóteses ou decisões de projeto, como o tamanho da camada de ar que representa a atmosfera, $h$, que eu irei considerar como sendo a troposfera, ou 12 kilometros, e a temperatura inicial, referente aos valores pré-industriais, $T(1800) = T_0 = 286,75 K$, ou 13,6 graus celsius, a maioria delas foi retirada de @stocker: como é o caso do raio da Terra, $R$, 6371 km; o calor específico do ar, $c$, 1000 J kg^-1 K^-1; a densidade do ar, 1.2 kg m^-3, a emissividade da Terra, $epsilon$, 0.6; a refletividade da Terra, $alpha$, 0.3; e a emissão solar, 1367 Wm^-2.

Embora essa equação seja razoávelmente simples, apresentando, inclusive, solução algébricas em alguns casos, solucioná-la através de métodos numéricos benefícia a adição de complexidade posterior para o desenvolvimento de simulações mais sofisticadas - adicionando mais itens de forçamento radiativos ou ciclos de feedback, por exemplo.

= Métodos numéricos utilizados

A equação diferencial descrita anteriormente é uma Equação Diferencial Ordinária (EDO), de primeira ordem, não linear e não homogênea. Por partes: ela é ordinâria por se tratar da derivação de uma função, Temperatura $T(t)$, em uma única variável, o tempo $t$; é de primeira ordem por só conter a derivada primeira dessa função; é não linear por conter termos não lineares, como o termo da radiação emitida pelo planeta, que é quadrático; e, finalmente, não homogênea por conter um termo constante, o forçamento radiativo dos gases de efeito estufa.

Além disso, o problema da modelagem climática se adequa muito bem a uma modelagem de valor inicial, visto que, quase sempre, queremos projetar resultados futuros a partir de medições iniciais. No caso deste trabalho, a referência inicial será o período pré-industrial, quando as concentrações dos gases de efeito estufa se mantinham aproximadamente constantes e, portanto, podem ser desconsideradas.

Com essas características, uma boa escolha para resolver a EDO são os métodos da família Runge-Kutta, em especial os de quarta ordem. Esses métodos discretizam passos de tempo, o que permite, além de resolver o problema, avaliar etapas intermediárias, uma característica relevante para modelos climáticos.

Antes de seguir com o método, entretanto, é preciso transformar as concentrações, de valores discretos, que vêm de medições experimentais de diversas organizações internacionais, como o @noaa-data, em uma função contínua no tempo, afinal, é provável que o passo do algoritmo não respeite o tempo das medições disponíveis publicamente. Para isso usarei uma função de regressão não linear, disponível na biblioteca `scipy`, chamada `curve_fit`, gerando a @gg_curvefit e os parâmetros necessários para descrever as duas funções de concentração de gases no tempo:

#figure(
  image("imgs/gg_curvefit.png", width: 120%),
  caption: [
    Resultado da regressão em cima dos dados experimentais da concentração de $"CO"_2$ e $"N"_2"O"$ na atmosfera . Fonte: próprio autor, com dados de @ourworldindata.
  ],
) <gg_curvefit>

Assim, temos todas as informações que precisamos parar começar a iterar o RK4. Um último ajuste a ser feito é a mudança de forma da equação, deixando a parte diferencial isolado na esquerda: $"dT"/"dt" = f(t, T)$. Isso pode ser feito dividindo a equação inteira por $4 pi R^2 h rho c$:

$ (d T(t))/(d t) = ((1 − alpha) S_0)/(4 h rho c) − ( epsilon sigma T(t)^4 )/( h rho c) + 1/(4 pi R^2 h rho c) [a_1 (C(t) - C_0)^2 + b_1 |C(t) - C_0| + c_1 dash(N(t)) + 5.36] ln(C/(C_0))  $

Sendo que as funções de concentração são dadas por:

$ "CO"_2(t) = 283.122 + 7.559 times 10^(-17) e^(0.021t) $
$ "N"_2"O"(t) = 263.248 + 6.569 times 10^(-12) e^(0.015t) $

O método de Runge Kutta de ordem 4 tem quatro parâmetros que balisam seus resultados, conforme representado na @rk4-l2c, estes podem ser calculos da seguinte forma:

$ k_1 = f(t_i, T_i) $
$ k_2 = f(t_i + h/2, T_i + h/2 k_1) $
$ k_3 = f(t_i + h/2, T_i + h/2 k_2) $
$ k_4 = f(t_i + h, T_i + h k_3) $

#figure(
  image("imgs/rk4.png", width: 80%),
  caption: [Representação visual da contribuição de cada parâmetro no RK4. Fonte: @manualcalculo]
) <rk4-l2c>

Onde $h$ é o _passo_, ou, o incremento no tempo que iremos aplicar na função. Com o valor dos $k$, a temperatura no passo seguinte é calculada realizando uma média ponderada deles:

$ T_(i+1) = T_i + h/6 (k_1 + 2k_2 + 2 k_3 + k_4) $

= Resultados

Com todas as bases teóricas definidas, foi criado um programa de terminal, `CLI` (_Command Line Interface_), que permite a manipulação de diversos parâmetros de forma simples e rápida, conforme demonstrado na @cli. O programa foi criado na linguagem de programação `Python` e toda a lógica foi desenvolvida do zero, sem apoio de bibliotecas prontas.

O programa já está carregado com os valores selecionados no texto. Ao usar estes valores padrão, porém, o programa devolve uma evolução muito pequena de temperatura:

```
Temperatura em 1800: 13.60 oC.
Temperatura estimada em 2026: 13.60 oC.
Aquecimento de 0.00014oC.
```

#figure(
  image("imgs/cli.png", width: 80%),
  caption: [Imagem da interface em linha de comando que permite manipular a simulação. Fonte: Próprio Autor.]
) <cli>

Ao analisar o motivo, identifiquei que ele está relacionado à ordem de grandeza das dimensões escolhidas, tanto pro raio da Terra, quanto para a camada de ar atmosférico: por esterem em kilometros, os valores ficam muito maiores do as demais grandezas, deixando a evolução lenta.

Ao escolher uma camada de ar atmosférico menor, por exemplo, com apenas um metro, o valor encontrado fica bem mais próximo do resultado real:

```
Temperatura em 1800: 13.60 oC.
Temperatura estimada em 2026: 14.90 oC.
Aquecimento de 1.29879oC.
```

A grande vantagem da ferramenta ser uma CLI é justamente essa possibilidade de parametrizar a simulação para identificar os valores que melhor representam o sistema.

Finalmente, é possível exportar os valores da simulação em um arquivo CSV para análise posterior ou plotar um gráfico, @results, diretamente pela linha de comando, usando o seguinte comando:

```bash
uv run main.py --atm-height=1 --no-radiative-forcing --plot
```

#figure(
  image("imgs/results.png", width: 80%),
  caption: [Resultados da simulação com valores modificados. Fonte: Próprio Autor.]
) <results>


= Conclusões

Embora os resultados com os valores escolhidos inicialmente não tenham sido satisfatórios, o algoritmo de solução numérica, foi. Ao optar por criar classes separadas e modulares, foi possível propor uma solução genérica, capaz de resolver outros problemas pelos métodos da família Runge-Kutta. A abordagem de criar uma interface de linha de comando também gerou oportunidades positivas para colaborações futuras, pela facilidade de modificação.

Além da correção dos parâmetros padrão escolhidos, uma outra melhoria futura no trabalho seria o desenvolvimento de um código para a regressão não linear da curva nos dados experimentais do de concetração dos gases do efeito estufa. O método de linerização e regressão linear, estudada no curso, não gerou bons resultados nos meus testes, então acabei optando por uma solução já existente, por este não ser o foco do trabalho.

O trabalho serviu seu propósito na consolidação dos conhecimentos em Cálculo Numérico, aplicados a um problema real e aplicado.

#bibliography(
  "references.yml",
  full: false,
  style: "abnt.csl",
)
