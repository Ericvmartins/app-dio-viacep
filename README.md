# App de Consulta de CEP com Flutter

<!-- Sugestão: Crie uma imagem de capa para o seu projeto -->

Uma aplicação móvel desenvolvida em Flutter para consultar, guardar e gerir Códigos de Endereçamento Postal (CEPs) do Brasil. O projeto utiliza a API pública do **ViaCep** para obter os dados de endereço e o **Back4App** como backend para persistência de dados.

## Funcionalidades

* **Consulta de CEP:** Busca em tempo real por um CEP através da API do ViaCep.
* **Armazenamento na Nuvem:** Guarda automaticamente os CEPs consultados no Back4App, evitando consultas duplicadas.
* **Listagem e Pesquisa:** Exibe todos os CEPs guardados numa lista e permite filtrar os resultados em tempo real.
* **Gestão de CEPs:**
    * **Editar:** Altera os dados de um endereço já guardado.
    * **Excluir:** Remove um CEP da lista.
    * **Copiar:** Copia o endereço completo para a área de transferência com um único toque.
* **Ecrã de Detalhes:** Mostra todas as informações de um CEP (IBGE, DDD, etc.) num ecrã dedicado.
* **Integração com Mapas:** Abre a localização do endereço no Google Maps.
* **Interface Melhorada:**
    * Máscara de input para o formato `#####-###`.
    * Tema visual personalizado com a fonte *Poppins*.
    * Feedback ao utilizador com notificações e indicadores de carregamento.

## Screenshots

| Ecrã Principal                                      | Ecrã de Detalhes                                   | Ecrã de Edição                                     |
| :--------------------------------------------------: | :------------------------------------------------: | :------------------------------------------------: |
| <img width="384" height="885" alt="Image" src="https://github.com/user-attachments/assets/b79e3bf4-9031-4147-88fc-855718a48a8e" /> | <img width="379" height="887" alt="Image" src="https://github.com/user-attachments/assets/085cd072-bdfa-4924-9baa-9cb09f4b0212" />| <img width="376" height="882" alt="Image" src="https://github.com/user-attachments/assets/1fa9244b-e100-4523-bc61-7fdfef07e773" /> |

## Tecnologias Utilizadas

<img align="center" alt="Flutter" height="40" width="50" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/flutter/flutter-original.svg" />
<img align="center" alt="Dart" height="40" width="50" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/dart/dart-original.svg" />
<img align="center" alt="Back4App/Parse" height="40" width="120" src="https://raw.githubusercontent.com/parse-community/parse-logo/main/logo-text-horizontal-dark.svg" />

<br>

* **Flutter:** Framework para desenvolvimento de aplicações multiplataforma.
* **Dart:** Linguagem de programação.
* **Back4App:** Backend como serviço (BaaS) baseado em Parse Platform.
* **ViaCep API:** API pública para consulta de CEPs.
* **Pacotes Flutter:**
    * `parse_server_sdk_flutter`: Integração com o Back4App.
    * `http`: Realização de chamadas de rede.
    * `url_launcher`: Abertura de links externos (Google Maps).
    * `mask_text_input_formatter`: Formatação do campo de CEP.
    * `google_fonts`: Utilização de fontes personalizadas.

## Como Executar o Projeto

Para executar este projeto localmente, siga os passos abaixo:

1.  **Clone o Repositório**
    ```bash
    git clone https://github.com/Ericvmartins/app-dio-viacep.git
    cd app-dio-viacep    
    ```

2.  **Configure as Chaves do Back4App**
    * Na pasta `lib/`, renomeie o ficheiro `constants_example.dart` para `constants.dart`.
    * Abra o ficheiro `constants.dart` e insira as suas credenciais (`Application ID` e `Client Key`) do Back4App.
    ```dart
    // lib/constants.dart
    const String keyApplicationId = 'SUA_APPLICATION_ID';
    const String keyClientKey = 'SUA_CLIENT_KEY';
    ```

3.  **Instale as Dependências**
    ```bash
    flutter pub get
    ```

4.  **Execute a Aplicação**
    ```bash
    flutter run
    ```

## Estrutura do Projeto

O código está organizado da seguinte forma para facilitar a manutenção:

* `lib/main.dart`: Ponto de entrada da aplicação, configuração do tema e inicialização.
* `lib/models/`: Contém os modelos de dados (ex: `cep_model.dart`).
* `lib/screens/`: Contém os ecrãs da aplicação (ex: `home_screen.dart`, `details_screen.dart`).
* `lib/services/`: Contém a lógica de negócio e comunicação com APIs (ex: `api_service.dart`).
* `lib/constants.dart`: Armazena as chaves de API (este ficheiro é ignorado pelo Git).
