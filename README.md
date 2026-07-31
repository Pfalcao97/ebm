# Modelo Climático de Balanço de Energia
## TCC - Do Cálculo à Simulação Numérica - L2C

Este repositório é referente ao trabalho de conclusão do curso [**"Do Cálculo à Simualação Computacional"**](https://l2c.dev.br/lp/), ministrado pelo [Prof. Rafael Gabler](https://www.linkedin.com/in/prof-rafael-gabler-gontijo-087b3832a/) e oferecido pela [**L2C**](https://l2c.dev.br/). Um código autoral será desenvolvido a fim de aplicar os conhecimentos aprendidos ao longo do curso.

O tema escolhido foi o desenvolvimento de **um modelo climático de balanço de energia** (EBM - _Energy Balance Model_), que é um modelo simplificado e zero-dimensional, usado para fins didáticos, para explicar o problema da previsão do clima.


## Critérios para obtenção do Certificado de Desempenho

Para obter o certificado de desempenho, o aluno deverá desenvolver um trabalho final que atenda aos seguintes requisitos:

### 1. Código computacional autoral

Desenvolver um código inédito, de autoria própria;

Linguagens permitidas:
- **Python**
- Fortran
- C++

O código deve:
- Resolver um problema prático de engenharia ou ciências aplicadas;
- Utilizar um ou mais métodos numéricos abordados no curso.

### 2. Repositório no GitHub

O projeto deve ser disponibilizado em um repositório público;

Deve conter:

- Código organizado e comentado;
- Arquivo README.md com:
- Descrição do problema;
- Explicação do funcionamento do código;
- Instruções de execução;

Objetivo: permitir que outras pessoas compreendam, utilizem e evoluam o código (filosofia _open-source_).

### 3. Relatório técnico em PDF

O relatório deve conter:

- **Introdução:** motivação do problema escolhido;
- **Fundamentação teórica:** Modelagem matemática e equacionamento do problema;
- **Métodos numéricos utilizados:** Descrição e justificativa das escolhas;
- **Resultados:** Apresentação e análise dos resultados obtidos;
- **Conclusões:** Principais aprendizados, limitações e possíveis melhorias.

### 4. Vídeo explicativo (até 5 minutos)

Gravar um vídeo curto explicando:

- O problema abordado;
- A solução implementada;
- O funcionamento do código;
- 
Disponibilizar via link não listado do YouTube.

### 5. Destaque dos melhores trabalhos

Os 3 melhores trabalhos serão:

- Selecionados pelo professor;
- Divulgados no perfil oficial da L2C no LinkedIn.

## Como executar o código

Para executar o código, é necessário instalar o gestor de pacotes `uv`, que simplifica o compartilhamento de códigos Python. Isso pode ser feito pelo comando:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Ou na [página de instalação da ferramenta](https://docs.astral.sh/uv/getting-started/installation/). Com o `uv` instalado, pode-se iniciar o código, na pasta `/src`, executando:

```bash
uv run main.py
```

Ao passar a flag `--help` uma lista de todos os parâmetros disponíveis é apresentada:

```
Usage: main.py [OPTIONS] [ANO_INICIAL] [TEMP_INICIAL]

  Resolve um modelo climatico de balanço de energia usando o metodo Runge-
  Kutta.

Options:
  --ano-final INTEGER       Ano para estimar a temperatura (ao deixar em
                            branco, o ano atual e usado)
  --timestep FLOAT          Tamanho de passo
  --no-radiative-forcing    Nao usar forcamento radiativo
  --alpha FLOAT             Refletividade da Terra
  --epsilon FLOAT           Emissividade da Terra
  --rk-order INTEGER        Ordem do metodo Runge-Kutta
  --atm-height INTEGER      Tamanho da Atmosfera
  --solar-constant INTEGER  Constante Solar
  --max-iterations INTEGER  Numero maximo de iteracoes - protecao numerica
  --verbose                 Printar informacoes na tela
  --export                  Exportar dados como arquivo CSV
  --plot                    Plotar grafico com os dados da simulacao
  --help                    Show this message and exit.
```

Para realizar uma nova simulação, alterando, por exemplo: o ano inicial para 1900, a temperatura inicial para 287.5 K ( 14 oC), a altura da atmosfera para 2 metros e usar um método de Runge-Kutta de 2a ordem, ao invés de quarta, deve-se realizar o comando:

```bash
uv run main.py 1900 287.5 --atm-height 2 --rk-order 2
```

É possível exportar os dados como CSV ou plotar uma imagem, usando as flags `--export` e `--plot`, respectivamente.
