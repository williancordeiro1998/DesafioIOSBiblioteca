**Biblioteca iOS**

**Descrição**

Este aplicativo de Biblioteca iOS permite aos usuários gerenciar uma coleção pessoal de livros, utilizando SQLite como banco de dados através da biblioteca SwiftData. Ele também utiliza a Google Books API para buscar informações detalhadas de livros online.

**Funcionalidades Principais**

- **Cadastro de Livros**: Adicione novos livros à sua biblioteca, especificando título e autor.
- **Atualização de Livros**: Modifique informações como título, autor, status de leitura, data de início/completação, e rating.
- **Visualização de Detalhes**: Veja detalhes completos dos livros, incluindo informações fornecidas pela Google Books API.
- **Exclusão de Livros**: Remova livros da biblioteca conforme necessário.

**Tecnologias Utilizadas**

- **SQLite com SwiftData**: Armazena dados localmente utilizando SQLite, uma base de dados leve e eficiente, integrada através da biblioteca SwiftData para Swift.
- **Google Books API**: Permite a busca de detalhes de livros online, como título, autor, resumo e capas.
- **SwiftUI**: Utilizado para construir a interface do usuário de forma declarativa e reativa.

**Funcionalidades Detalhadas**

- **Cadastro de Livros**:
  - Utilize o formulário de adição de livros para inserir título e autor. As informações são armazenadas localmente no SQLite.
- **Atualização de Livros**:
  - Acesse a tela de edição para modificar detalhes como título, autor, status de leitura, datas e rating. As alterações são refletidas diretamente no banco de dados SQLite.
- **Visualização de Detalhes**:
  - Ao adicionar um livro ou ao selecionar um livro existente, a aplicação busca detalhes adicionais na Google Books API, como sinopse e capa do livro.
- **Exclusão de Livros**:
  - Exclua livros da biblioteca através da funcionalidade de deleção disponível na lista de livros.

**Como Executar o Projeto**

1. **Pré-requisitos**:
   1. Xcode 12 ou superior
   1. Conexão à internet para acessar a Google Books API
1. **Passos para Executar**:
   1. Clone o repositório localmente.
   1. Abra o projeto no Xcode.
   1. Certifique-se de configurar as dependências, se necessário.
   1. Execute o aplicativo em um simulador ou dispositivo iOS.

**Contribuição**

Contribuições são bem-vindas! Sinta-se à vontade para enviar pull requests para melhorar o código, adicionar novas funcionalidades ou corrigir bugs.

**Autor**

Willian Cordeiro Oliveira - [GitHub]([https://github.com/seu-username](https://github.com/williancordeiro1998))
