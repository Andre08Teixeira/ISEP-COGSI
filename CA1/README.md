# Este documento visa detalhar os passos seguidos para desenvolver o CA1

 - Começamos por configurar o git:
    - git config --global user.name "[name]" (configurar o nome de utilizador a utilizar nos commits)
    - git config --global user.email "[email address]" (configurar o email a utilizar nos commits)

## CA1 - Parte 1

### Para fazer o git clone no wsl2:

Fomos às definições do GitHub e geramos um "Personal Access Token" com permissões de escrita e depois utilizamos o seguinte comando para realizar o clone:
 - sudo git clone https://username:accesstoken@github.com/1181210/cogsi2425-1181210-1190384-1181242.git

### Passo 1

Depois de efetuado o clone adicionou-se uma pasta "CA1" e moveu-se o projeto do maven (descarregado do moodle) para dentro da mesma;

### Passo 2

Deu-se push das alterações efetuadas, seguindo-se os seguintes passos:

- "git add ." (adicionar todos os conteúdos adicionados/modificados à *staging area*);
- "git status" (para verificar as alterações efetuadas)
- "git commit -m 'mensagem'" (de forma a realizar o commit das alterações *staged*);
- "git push" (dar "upload" de todos os commits realizados no ramo local para o repositório);

### Passo 3

Gerou-se uma tag do tipo *lightweight* uma vez que esta representa a versão inicial da aplicação, neste caso 1.1.0. Para gerar a tag, efetuaram-se os seguintes comandos:
- "git tag 1.1.0"
- "git push origin 1.1.0" (este comando envia a tag especificada para o ramo remoto);

### Alterações à classe *Employee* e criação de testes unitários

### Passo 4

Modificamos a classe "Employee" na pasta tutrest/nonrest, adicionando-se o campo "JobYears";

### Passo 5

Deu-se commit e push destas mesmas alterações (comando já demonstrado no passo 2);

### Passo 6

Adicionou-se uma classe "EmployeeTest" no diretório "src/test/java/payroll/";

### Passo 7

Foram realizados testes unitários para os diferentes setters e o construtor da classe. Esses testes asseguram que a classe aceita apenas nomes e roles que não sejam vazios ou nulos, além de garantir que o valor de *jobYears* seja positivo e um número inteiro. A classe Employee também foi modificada, incorporando estas validações tanto no construtor quanto nos *setters* das propriedades correspondentes, assegurando a integridade dos dados ao instanciar ou modificar objetos dessa classe.

### Passo 8

Utilizou-se o comando "../mvnw test" para executar os testes desenvolvidos e verificar os seus resultados.

### Passo 9

Utilizaram-se se os comandos já descritos no passo 2 para realizar *commit* e *push* às alterações efetuadas.

### Passo 10

Criou-se a tag "1.2.0" e deu-se push à mesma (comandos já descritos no passo 3).

### Revert commit

### Passo 11

Criou-se um txt "revert.txt" e deu-se commit e push através dos comandos já acima mencionados (passo 2).

### Passo 12


Realizou-se o *revert* através do comando:
- "git revert [hash commit]" - criando um novo *commit* que desfaz as alterações introduzidas no *commit* anterior. 

Para obtermos o hash do *commit* no qual pretendiamos realizar *revert*, utilizamos o comando:
- "git log"

### Passo 13

Criou-se a tag "ca1-part1" e deu-se push à mesma:
- "git tag ca1-part1"
- "git push origin ca1-part1"

## CA1 - Parte2
	
### Criação de um campo Email para o Employee

### Passo 1

Para a nova *feature*, começamos por criar um novo *branch* usando o comando: 
- "git branch [branchName]"
 
Seguido do comando: 
- "git checkout [branchName]", para movermos o apontador do *branch* para o nosso novo *branch* criado. 

Alternativamente poderia ser utilizado:
- "git checkout -b [branchName]" (para executar ambas as funcionalidades em sequência);

### Passo 2

Para fazer o novo branch se tornar reconhecido no repositório remoto, foi utilizado o comando:
- "git push --set-upstream origin [branchName]", que cria o novo *branch* no repositório remoto, e também o configura como *Tracking branch*, fazendo os futuros *pushes* serem automaticamente direcionados para o branch do nome escolhido no repositório remoto.

### Passo 3

Utilizaram-se se os comandos já descritos no passo 2 (parte 1), para realizar *commit* e *push* às alterações efetuadas.

### Passo 4

De seguida foi criado um Pull Request na interface do GitHub de forma ao código poder ser revisto e aceite pelos outros desenvolvedores.

### Passo 5 

**Nota:** este passo foi efetuado por outro membro do grupo.

Para começar, este membro começou por realizar o *fetch* do respositório remoto:
- "git fetch" (descarrega todo o histórico dos *remote tracking branches*);

De seguida, realizou o *checkout* para alterar o ramo atual:

- "git checkout [branchName]" (de forma a mover o apontador *HEAD* para o ramo criado anteriormente);
 
## Passo 6

Desenvolveu-se os novos testes unitários para a propriedade do email e deu-se commit/push às alterações efetuadas;

## Passo 7

Criou-se a tag "1.3.0" e deu-se push à mesma.

## Passo 8

Após os membros realizarem o *code review* do *pull request* e testarem as novas alterações efetuadas, aceitou-se o mesmo no github e foi realizado o *merge* deste ramo com o ramo *main* através da interface.

### Criação da branch para validações de emails

**Nota:** este passo foi efetuado por outro membro do grupo.

### Passo 9

Começou-se por realizar o fetch das alterações.

Para criar a nova branch utilizou-se a alternativa referida anteriormente:
- "git checkout -b [branchName]", sendo fixing-invalid-email o nome da mesma.

### Passo 10

Após realizarmos todas as validações pedidas, deu-se *commit* e *push* das alterações na nova branch criada.

### Passo 11

Uma vez que era necessário fazer merge na branch principal (*main*) foram utilizados os seguintes comandos:
- git checkout main (alterar para a branch main);
- git pull origin main (garantir que a branch está atualizada);
- git merge fixing-invalid-email (merge com a branch criada) - neste caso não existiu qualquer conflito;

### Passo 12

Criou-se a tag "v1.3.1" e deu-se push à mesma. Como não houve nenhum conflito, criou-se a última tag "ca1-part2" e deu-se push à mesma.

### Passo 13

Durante a edição colaborativa desde ficheiro Readme, foi necessária a resolução de conflitos entre as mudanças realizadas nos commits locais com os commits remotos.
De forma a realizar o merge com resolução de conflitos foi necessário realizar um pull das mudanças seguido do comando
- "git merge", para realizar merge com o repositório remoto,

Seguido da edição do ficheiro em conflito, e da remoção dos caracteres gerados pelo git a representar as mudanças em conflito, de forma a deixar apenas as mudanças pretendidas, que neste caso foram mudanças simples de espaçamento de linhas. (Neste caso foi utilizado o editor VS Code)

![Exemplo de resolução de conflitos](images/gitMergeExample.png)

Após as mudanças necessárias foi feito o staging, commit e push das resoluções de conflito, tal como um commit normal.

## Solução alternativa ao Git para Controlo de Versões
	
Nesta secção é detalhada uma solução alternativa à utilizada nesta iteração, o GIT. 

### Introdução

Foi realizada uma pesquisa de outros sistemas de controlo de versões. Foram encontrados dois tipos de sistemas de controlo de versões: centralizados e distribuídos.
	
#### Sistemas de Controlo de Versões Centralizados
	
Num sistema de controlo de versões centralizado, todos os ficheiros e respetivo histórico são armazenados num único servidor central, não existindo uma cópia local do histórico para os utilizadores. Para realizar alterações, é necessário realizar o "check-out" dos ficheiros a partir do servidor, trabalhar neles localmente e, de seguida, realizar o "check-in" para atualizar o servidor central com as modificações efetuadas.

Alguns exemplos de sistemas centralizados incluem o "Subversion (SVN)" e o "Perforce". Uma desvantagem clara deste modelo é a dependência da disponibilidade do servidor: se o servidor estiver inacessível, consultar ou enviar alterações deixam de ser possíveis. Além disso, a colaboração com grandes equipas pode ser dificultada pelo congestionamento na comunicação com o servidor central.

Apesar dessas desvantagens, os sistemas de controlo de versões centralizados apresentam algumas vantagens, como um maior controlo central sobre o acesso e permissões, bem como a simplificação do histórico de alterações, uma vez que todas as modificações são registadas num único local. No entanto, estas características não se enquadram nas necessidades do projeto em questão, sendo que a alternativa escolhida baseia-se num sistema distribuído de controlo de versões, que oferece maior flexibilidade e independência.


#### Sistemas de Controlo de Versões Distribuídos
	
Nos sistemas de controlo de versões distribuídos, cada utilizador possui uma cópia completa de todo o repositório, incluindo os ficheiros e o histórico completo das alterações, armazenada na sua máquina local. Isto permite que se trabalhe nos ficheiros offline, sem a necessidade de se estar conectado a um servidor central. 
Uma vez concluídas as alterações, estas podem ser sincronizadas posteriormente com o repositório remoto, permitindo a partilha e a integração do trabalho com o de outros utilizadores.

Este modelo tem várias vantagens. Uma delas é a possibilidade de se trabalhar de forma assíncrona e independente, já que deixa de ser necessário se estar sempre conectado ao servidor central para aceder ao histórico ou para fazer *commits* locais. Outro benefício importante é a resiliência: como cada utilizador tem uma cópia completa do repositório, o risco de perda de dados devido a uma falha no servidor central é reduzido, pois qualquer utilizador pode restaurar o repositório.

Além disso, o controlo de versões distribuído facilita a colaboração em projetos de grande escala, devido à possibilidade de criação de ramos derivados de um ramo "principal". Este modelo torna o processo de *merge* entre diferentes ramos muito mais flexível e eficiente, pois é possível trabalhar de forma isolada num determinado ramo, testar alterações e, posteriormente, integrar essas alterações no ramo principal sem afetar o trabalho dos outros membros da equipa	

Exemplos de sistemas de controlo de versões distribuídos incluem o Git e o Mercurial. Para o presente trabalho foi escolhido o Mercurial.
	
#### Mercurial
	
O mercurial, tal como o GIT, é gratuito. Este apresenta, para alguns, a vantagem de ser mais simples de utilizar, sendo os seus comandos mais intuitívos. Neste, as mudanças são registadas de forma linear ao longo do tempo numa estrutura chamada *revision log (RevlogNG)*. Esta abordagem ao seguimento de alterações é particularmente eficaz para projetos de larga escala, tanto em número de ficheiros como de colaboradores.

Depois de uma mudança ser registada no histórico do Mercurial, ela torna-se imutável e não pode ser removida – exceto através de um *rollback*, que também é registado como uma nova alteração. Este registo permanente é útil para determinar quando e por quem as alterações foram introduzidas no repositório.
		
##### Principais comandos do Mercurial e como se comparam com o git
		
Os principais comandos utilizados no mercurial são:
- **hg clone** - para realizar clone a um repositório remoto - o "equivalente" no git como o "git clone";
- **hg init** - para inicializar um repositório - o "equivalente" no git como o "git init";
- **hg add [ficheiro]** - adiciona os ficheiros para o próximo *commit* - pode ser comparado no git como o "git add [ficheiro]";
- **hg commit** - cria um *changeset* no repositório local - o "equivalente" no git como o "git commit";
- **hg log** - permite verificar alterações - o "equivalente" no git como o "git log";
- **hg pull** - obtém todas as mudanças do repositório remoto para o repositório local caso a opção "-u" seja especificada - o "equivalente" no git como o "git pull";
- **hg push** - envia todas as alterações do repositório local para repositório remoto- o "equivalente" no git como o "git push";
- **hg serve** - cria um servidor web no qual os envolvidos podem visualizar o histórico e realizar o "pull" do mesmo;
- **hg merge** - realiza a junção de duas linhas diferentes de histórico - o "equivalente" no git como o "git merge"; 
- **hg rollback** - realiza o rollback para a versão anterior - o "equivalente" no git como o "git revert 'commit' ";
- **hg tag tagname** - permite criar uma tag - o "equivalente" no git como o "git tag tagname";
 		
Como se pode observar o mercurial tem, para alguns, a vantagem de ser mais simples. No entanto, o GIT é mais poderoso e permite realizar um conjunto mais alargado de ações.

#### Implementação do CA1 com o Mercurial
 
Após alguma pesquisa, decidimos escolher o **codebasehq** como a plataforma de hosting do nosso servidor.
 
##### Passo 1
Começamos por aceder ao wsl e efetuamos o comando "hg init" para definir a pasta corrente como sendo um repositório, gerando-se uma pasta ".hg", tal como espectável.

##### Passo 2

De seguida, criamos uma pasta "teste" e executámos o comando "hg add" que adiciona as alterações. Foi possível observar o sucesso desta operação através do comando "hg status" que demonstrou as alterações pendentes a enviar.

##### Passo 3

Após isso, realizou-se o "hg commit -m 'Initial commit'" para realizar o commit das alterações para o repositório remoto.

##### Passo 4

Terminou-se utilizando o comando "hg push ssh://hg@codebasehq.com/isep/cogsi-ca1/cogsi-ca1.hg" para enviar as alterações para o repositório remoto;

##### Passo 5

Repetiram-se os passos 1 a 4 para enviar a pasta "tut-rest" para o repositório, semelhante à parte inicial do CA1-Part1. Como estavam dois membros da equipa a efetuar alterações ao mesmo tempo (onde o primeiro
membro realizou o push da pasta "teste" e o segundo da pasta "tut-rest"), este segundo membro teve conflitos o dar o push e teve de realizar os comandos:
- "hg pull ssh://hg@codebasehq.com/isep/cogsi-ca1/cogsi-ca1.hg" (de forma a
obter as alterações mais recentes);
- "hg merge" (para juntar as suas modificações locais às mais recentes do branch remoto).
Após isto, realizou-se o commit do merge e assim, já foi possível realizar o push para o repositório remoto; 

##### Passo 6

Para a criação da tag "1.1.0", realizou-se o comando "hg tag 1.1.0", seguido de um "hg push" que enviou a tag para o repositório remoto;

##### Passo 7 - Criar o ramo "email-field"

Para simplificar, decidiu-se realizar o ca1-part2, juntando também as alterações do ca1-part1. Para isso, começou-se por criar um *branch* com o nome "ca1-employee-jobyearsandemail", executando o seguinte comando:
- "hg branch "ca1-employee-jobyearsandemail";

##### Passo 8
 
De seguida, adicionou-se o campo do "jobyears" e "email" à classe "Employee", bem como se desenvolveu os testes unitários para estes dois campos. Após isto, realizou-se o *commit* e o *push*:
- "hg add .";
- "hg commit -m [mensagem];
- "hg push [endereço]";

##### Passo 9

Por fim, realizou-se o merge com o ramo principal. Para isso executaram-se os seguintes comandos:
- "hg branches" - para verificar os ramos disponíveis;
- "hg update default" - para definir o ramo atual como sendo ramo "default";
- "hg merge ca1-employee-jobyearsandemail" - para realizar o merge com o ramo descrito;
- "hg commit -m "merge"" - para realizar o *commit* do merge;
- "hg push" - para enviar as mudanças para o repositório remoto;
   
##### Passo 10

Para a criação da tag "1.3.0", realizaram-se os mesmos comandos referidos no passo 6.

##### Passo 11 - Criar o ramo para corrigir bugs
	
Para criar o ramo foi de novo utilizado o comando:
- "hg branch "fixing-invalid-email""

#### Passo 12

Foi editado o ficheiro de Employee e EmployeeTest, para incluir as validações em falta no Email. Após estas alterações foi realizado commit e push para o repositório remoto, da mesma forma anteriormente referida.

#### Passo 13

Após testar estas alterações, foi realizado o merge deste ramo com o ramo default, da mesma forma referida anteriormente. Por fim, criaram-se as tags 1.3.1 e CA1-Part2, associadas ao commit final.