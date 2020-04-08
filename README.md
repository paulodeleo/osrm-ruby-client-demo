# OSRM ruby client gateway pattern POC

- Precisamos testar
  - que parametros temos que informar como entrada e quais esperar na saída
  - que parametros são obrigatórios
  - que parametros tem qual formato
  - que diferenças existem entre nomes e valores de parametros entre os diferentes providers, drivers e services
  - que definimos interfaces com os parametros como faz sentido para nosso negócio, independentemente do formato dos drivers e providers
  - que erros em cada camada sejam facilmente identificáveis e tratáveis
  - que timeouts de providers ou drivers sejam estabelecidos com tempo pequeno e sejam tratados silenciosamente
  - que o tratamento de interfaces e timeouts sejam desacoplados dos services

- Podemos testar a implementação de cada provider separadamente
- Podemos testar a implementação de cada driver separadamente dos providers
- Podemos testar a implementação de cada service separadamente dos drivers
- Podemos ter validações e tratamentos e implementações diferentes nas camadas de service e de drivers
- Podemos ter interfaces definidas separadamente entre service, driver e provider

- Se quisermos que cada o GeolocationService retorne previsão de distância e duração de bike e carro, fazemos duas chamadas em qual camada?