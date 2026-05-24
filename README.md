# Contador de Protocolos

Projeto simples criado para resolver um problema pessoal de gerenciamento e contagem diária de protocolos. O objetivo é facilitar o acompanhamento da produtividade através de uma interface minimalista e um dashboard de performance, com os dados sendo salvos diretamente em nuvem de forma leve.

## 🛠️ Stack Utilizada

### Frontend (Aplicação)
* **HTML5** e **CSS3** nativos (sem frameworks)
* **JavaScript Vanilla** para lógica de contagem e renderização dinâmica do dashboard
* Design minimalista e responsivo
* Comunicação com API via `fetch()`

### Backend (Infraestrutura Serverless AWS)
* **Amazon API Gateway:** Exposição da API REST
* **AWS Lambda:** Funções para processar as requisições GET/POST
* **Amazon DynamoDB:** Banco de dados NoSQL utilizado para salvar o histórico diário de contagens (utilizando a data `yyyy-mm-dd` como Hash Key)

## 📦 Estrutura do Projeto

* `aplicacao/`: Contém os arquivos da interface web.
  * `index.html`: A página principal onde a contagem de protocolos é realizada e salva.
  * `performance.html`: Um dashboard dinâmico que exibe o histórico de protocolos realizados, consumindo dados do DynamoDB e permitindo filtragem por intervalo de datas.
* `infraestrutura/`: Destinado aos arquivos de infraestrutura (como códigos Lambda e configurações de IaC, se aplicável).
* `testes/`: Destinado a testes da aplicação.

## 🚀 Funcionalidades

1. **Interface de Contagem:** Permite adicionar ou subtrair a quantidade de protocolos de forma rápida.
2. **Salvamento em Nuvem:** Envia a quantidade do dia diretamente para o DynamoDB através do API Gateway + Lambda.
3. **Dashboard de Performance:** Busca o histórico completo de protocolos.
4. **Filtro de Datas:** Permite no dashboard a filtragem avançada por períodos (Data Inicial até Data Final) para analisar a performance ao longo do tempo.

## 📝 Como usar localmente

Como o frontend é composto apenas de HTML, CSS e JS puros, basta abrir o arquivo `aplicacao/index.html` em qualquer navegador para rodar o projeto localmente. As requisições de salvar e consultar os dados apontam para a URL do Amazon API Gateway configurada na nuvem.