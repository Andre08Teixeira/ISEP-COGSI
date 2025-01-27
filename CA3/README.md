# CA3

## Parte 1

### Inicialização da máquina

Para inicializar a máquina virtual Vagrant foi utilizado o comando 

``vagrant init bento/ubuntu-22.04``

Este comando tem a funcionalidade de inicializar o ficheiro Vagrantfile, e neste caso escolhemos definir a propriedade opcional que seleciona a instalação a utilizar, bento/ubuntu-22.04.
Dentro do ficheiro gerado definimos configurações no ficheiro gerado, começando por definir o nome da Máquina:

```
config vm.provider :virtualbox do |vb| 
    vb.name = 'COGSI-VM-CA3-P1'
end
```

Esta propriedade define o nome da nossa máquina virtual como 'COGSI-VM-CA3-P1', no caso do provider de máquinas virtuais utilizado for o VirtualBox.

Para configurar as dependências a instalar, foi também adicionado os comandos:

```
  sudo apt-get update
  sudo apt-get install -y git curl vim openjdk-17-jdk
```

Tal como em unix, estes comandos irão instalar as dependências descritas, neste caso git, curl, vim e JDK.

Após a inicialização executámos o comando ``vagrant up``, que, na primeira utilização, descarrega (caso não exista) e instala a Máquina Virtual, o sistema operativo selecionado e as dependências definidas na *VagrantFile*.
Esta instalação é feita utilizando as capacidades do provider de VMs configurado.

### Automatização da clonagem do repositório

Para clonar o repositório foi necessário disponibilizar à *Virtual Machine* vagrant a chave SSH de cada utilizador, de forma a manter a confidencialidade das chaves usadas para clonar o repositório privado.
Uma chave SSH foi gerada e configurada na conta git seguindo os [guias oficiais github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), e na vagrant file foram adicionados os seguintes comandos:

```
  config.vm.provision "file", source: "~/.ssh/id_ed25519", destination: "/home/vagrant/.ssh/id_ed25519"
```

Este comando copia a chave SSH gerada anteriormente localizada na pasta .ssh do utilizador que inicializa a Máquina Virtual para a pasta .ssh desta mesma.

Seguido destes comandos no bloco ```config.vm.provision "shell"```

```
    chmod 600 /home/vagrant/.ssh/id_ed25519
    chown vagrant:vagrant /home/vagrant/.ssh/id_ed25519

    ssh-keyscan -H github.com >> /home/vagrant/.ssh/known_hosts
    chmod 644 /home/vagrant/.ssh/known_hosts
    chown vagrant:vagrant /home/vagrant/.ssh/known_hosts
    ssh-add /home/vagrant/.ssh/id_ed25519
    eval "$(ssh-agent -s)"
```

Estes comandos oferecem as permissões necessárias às chaves de SSH e ao ficheiro *known_hosts*, e iniciam o ssh-agent. Durante as nossas sessões de teste estes comandos não foram necessários em todas as máquinas hosts utilizadas, mas de forma a garantir que o cenário das chaves SSH é consistentemente apto de realizar a clonagem do repositório em qualquer máquina, estas condições foram adicionadas.

```
 git clone git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git
```

Finalmente este comando realiza o git clone do repositório.

### Automatização da execução de ambas as soluções.

De forma a poder compartimentalizar a execução dos passos de *provisioning* do projeto, foram criados 3 blocos de provisioning do tipo "shell": "init", "runTutRest" e "runChatProject".

Cada um destes scripts de provisioning são semelhantes, pois todos executam comandos shell, mas no caso de ambos os scripts de runTutRest e runChatProject, estes estão ambos configurados como `run: never`, de forma a nunca serem executados no ```vagrant up``` inicial, apenas quando é executado o comando ```vagrant provision --provision-with [provision]```

```
  config.vm.provision "init", type: "shell" do |s|
  config.vm.provision "runTutRest", type: "shell", run: "never" do |s|
  config.vm.provision "runChatProject", type: "shell", run: "never" do |s|
```

Desta forma conseguimos realizar um vagrant up neutro, incluindo todos os passos anteriormente referidos, e deixando-nos a oportunidade de poder utilizar a VM inicializada para executar qualquer dos dois projetos.
Ambas as soluções executam um servidor em portas distintas na máquina virtual. Estas portas não são acessíveis à máquina host, impossibilitando a utilização dos seus serviços fora do ambiente da máquina.
Para resolver esta situação foi necessário realizar *Port Forwarding* dos portos da VM.

```
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 59001, host: 59001
```

Neste caso os portos 8080 e 59001 da VM (guest), foram traduzidos para os portos 8080 e 59001 respetivamente da máquina Host.

Os scripts propriamente ditos para ambos estes projetos são como se segue:

```
  # Provisioning para o projeto tutRest
  config.vm.provision "runTutRest", type: "shell", run: "never" do |s|
    s.inline = <<-SHELL
      cd cogsi2425-1181210-1190384-1181242/CA2/tutRestGradle/nonrest

      ../gradlew bootRun

    SHELL
  end

  # Provisioning para o projeto tutRest
  config.vm.provision "runChatProject", type: "shell", run: "never" do |s|
    s.inline = <<-SHELL
      cd cogsi2425-1181210-1190384-1181242/CA2/gradle_basic_demo-main

      ./gradlew runServer
    SHELL
  end
```

Ambos os scripts podem ser reduzidos a uma mudança de diretório para onde o seu respetivo projeto, "tutRestGradle" e "gradle_basic_demo-main" respetivamente estão localizados e executa a task *Gradle* para os executar. 

### Assegurar retenção do conteúdo da base de dados H2

A retenção da base de dados H2 no projeto TutRest foi realizada através de uma criação de uma pasta partilhada entre a Máquina Virtual, e o diretório na máquina *host* que contém a Vagrantfile respetiva.
A pasta foi interligada pelas duas máquinas através da adição do comando de provisioning que se segue:
```config.vm.synced_folder "./shared/", "/shared"```
Sendo o primeiro argumento a localização do diretório na máquina host e o segundo este mesmo na máquina virtual.

Para a aplicação direcionar a base de dados para esta pasta, foi adicionado o ficheiro application.properties no diretório src/main/resources, com as seguintes configurações:

```
spring.datasource.url=jdbc:h2:file:/shared/nonRestData
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=admin
spring.datasource.password=adminpassword
spring.jpa.defer-datasource-initialization=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.ddl-auto=update
```

"spring.datasource.url" representa a localização da base de dados, "jdbc:h2:file:" afirma que é uma base de dados guardada num ficheiro, com o seu caminho seguido.

As 3 propriedades "spring.jpa" são configuradas para certificar que a base de dados é persistida em vez de ser reiniciada em cada execução.

## Parte 2

### Execução do projeto Spring e DB H2 em VM separadas

Para permitir a execução da base de dados numa instância separada, foi primeiro atualizado o ficheiro application.properties previamente referido

```
spring.datasource.url=jdbc:h2:tcp://192.168.33.11:9092/nonRestData
```

Desta forma o servidor conectar-se-á através de jdbc para a base de dados localizada no endereço e porto especificados, na localização nonRestData especificada.

Também foi adicionado ao build.gradle do projeto a seguinte task:

```
task startH2Server(type: JavaExec) {
    group = "DevOps"
    description = 'Inicializa a base de dados H2'
    classpath = sourceSets.main.runtimeClasspath
    mainClass = 'org.h2.tools.Server'
    args = ['-tcp', '-tcpAllowOthers', '-tcpPort', '9092', '-baseDir', '/shared']
}
```

Esta tem a funcionalidade de executar a base de dados no porto 9092, sendo o diretório "/shared" onde o conteúdo é guardado (O mesmo diretório partilhado previamente referido.)

Na Vagrantfile, foi adicionado o seguinte provision script, que executa o servidor de bases de dados:

```
  config.vm.provision "runTutRestDB", type: "shell", run: "never" do |s|
    s.inline = <<-SHELL

      #Mover para o novo diretório criado
      cd /home/vagrant/home/cogsi2425-1181210-1190384-1181242/CA2/tutRestGradle/nonrest

      ../gradlew startH2Server

    SHELL
  end
```

De forma a ambas as execuções da base de dados e do servidor se localizarem em máquinas virtuais separadas, foi adicionado um bloco *"define"*, que encapsula o provisioning e a configuração de cada máquina, de acordo com o inserido no respetivo bloco. A partir do momento que estes blocos são definidos, o vagrant deixa de considerar a vagrantfile como configuração para uma máquina virtual "default", sendo agora uma configuração para as máquinas virtuais denominadas nestes blocos.

```
config.vm.define "tutRest" do |tutRest|
# Conteudo de configuração e provisioning tutRest
end

config.vm.define "tutRestDB" do |tutRestDB|
# Conteudo de configuração e provisioning tutRestDB
end
```

Todo o conteúdo encapsulado dentro deste bloco é único para a VM definida e o exterior partilhado portanto as configurações exteriores e o *provisioning script* "init" previamente referido será executado para ambas as VMs.

### Alocação de Recursos da VM

Ao definir a quantidade de memória e CPUs, conseguimos otimizar os recursos da VM, o que é crucial para garantir um desempenho adequado, especialmente ao executar aplicações que requerem mais recursos, como o Spring Boot e o H2 Database. Assim, alocamos 4096 MB (4 GB) de memória RAM para a VM, o que é um valor adequado para suportar a operação de um servidor e uma base de dados.

Além disso, alocamos 2 CPUs para a VM, o que pode melhorar a performance, especialmente ao executar processos que exigem maior poder de processamento. Esta configuração ajuda a evitar falhas de desempenho e assegura que a aplicação funcione de maneira fluida.

```
  config.vm.provider :virtualbox do |vb|
   vb.memory = "4096" # Aloca 4 GB de memória para a VM 
   vb.cpus = 2     # Aloca 2 CPUs para a VM
  end
```

As propriedades memory e cpus, alocam a memória em Megabytes e o número de CPUs respetivamente.
Quando ao espaço de disco disponível, este é pré-definido em cada "box" e necessitaria de alteração desse espaço disponível após a instanciação da VM, opção que não foi realizada neste projeto.

### Utilização de chaves SSH para acesso

Antes da configuração, foi gerada uma chave SSH entitulada de vagrantCA3Key, e inserida no respetivo diretório SSH de cada utilizador.
Depois, foi configurado o seguinte, na secção global da Vagrantfile:

```
  # Copy public SSH key to VM
  config.vm.provision "file", source: "~/.ssh/vagrantCA3Key.pub", destination: "~/.ssh/authorized_keys"

  # Paths to the private key
  config.ssh.private_key_path = [
  "~/.vagrant.d/insecure_private_key",
  "~/.ssh/vagrantCA3Key"
  ]

  # Disable Vagrant's default insecure key insertion
  config.ssh.insert_key = false
```

O primeiro comando, insere a chave pública para o diretório de chaves ssh autorizadas na respetiva *Virtual Machine*, o segundo define os possíveis caminhos para a chave privada a ser utilizada, e o último comando remove o processo de inserção de chave insegura que o Vagrant realiza por defeito.

### Automatização do processo de startup

No momento de startup, foi necessário causar a aplicação servidor a esperar pela Base de dados, de forma a poder ser executada. Isto foi realizado através de uma simples adição no provisioning script em shell da VM tutRest:

```
        while ! nc -z 192.168.33.11 9092; do   
          sleep 5
          echo "Database not available, retrying in 10 seconds"
        done
```

Este script, utilizando o comando nc -z (NetCat), verifica se o porto 9092 no endereço 192.168.33.11 está disponível de 5 em 5 segundos, até se encontrar disponível e assim realiza o resto do processo de execução do servidor, com a certeza que poderá se conectar à Base de Dados.

### Firewall rule ufw

Para que as regras do firewall entrem em vigor, é necessário ativá-lo com o seguinte comando:

```sudo ufw enable```

Depois de ativar o firewall, utilizamos os seguintes comandos para configurar as regras:

```sudo ufw allow from 192.168.33.11 to any port 9092```

Este comando permite conexões da VM de aplicação (192.168.33.11) para a porta 9092, que é utilizada pelo H2 Database.

```sudo ufw deny 9092```

Este comando nega todas as outras conexões para a porta 9092, garantindo que apenas a app VM tenha acesso à base de dados.

Por último utilizamos ```sudo ufw status``` para confirmar que as regras foram estabelecidas corretamente.

## Solução alternativa ao Vagrant

Nesta secção é detalhada uma solução alternativa à utilizada nesta iteração, o Vagrant.

### Introdução

Foi realizada uma pesquisa de outras ferramentas semelhantes ao Vagrant. Algumas das alternativas encontradas foram: o terraform, o packer, entre outros.

A alternativa selecionada foi o **packer**, no entando de seguida são comparadas as três ferramentas (vagrant, packer e terraform).

O **packer** corresponde a uma ferramenta cujo o seu principal objetivo é criar imagens de máquinas idênticas para múltiplas plataformas de virtualização, cloud e containers provenientes de uma única configuração. Esta é uma ferramenta leve, que permite ser executada na maior parte dos sistemas operativos. Para além disso, a sua performance é um dos pontos positivos, uma vez que permite a criação das imagens refereidas em paralelo.

### Como o Packer Funciona

O **packer** guia-se pelo um ficheiro de configuração, geralmente de extensão *JSON* ou *HCL* (*HarshiCorp Configuration Language*), onde se especifíca o tipo de imagem a ser criada, o provedor, detalhes de configuração e outras instruções de *provision* pretendidas. Dentro deste ficheiro é possível configurar diversas secções, entre elas destacam-se:

- **Builder:** especifíca-se o ambiente de geração da imagem pretendido (ex:. AWS, Azure, VirtualBox, entre outros). É possível ter múltiplos *builders* por ficheiro de configuração, gerando-se assim múltiplas imagens. Abaixo encontra-se um pequeno exemplo da sintaxe, retirado da documentação do *website* do packer:
  
  ```
  "builders": [
      {
        "type": "vmware-vmx",
        "source_path": "/opt/ubuntu-1404-vmware.vmx",
        "ssh_username": "vagrant",
        "ssh_password": "vagrant",
        "shutdown_command": "sudo shutdown -h now",
        "headless": "true",
        "skip_compaction": "true"
      }
    ],
  ```

- **Provisioners:** *scripts* ou ferramentas utilizados para instalar e configurar o *software* da imagem. Podem corresponder a *scripts* próprios, ou ferramentas como o Ansible. Exemplo:
  
  ```
   "provisioners": [
      {
        "type": "shell",
        "inline": [
          "sudo apt-get install -y python-pip",
          "sudo pip install ifs",
          "sudo ifs install consul --version=0.5.2"
        ]
      },
      {
        "type": "file",
        "source": "/usr/local/bin/consul",
        "destination": "consul",
        "direction": "download"
      }
    ],
  ```

- **Post-Processors:** passos efetuados após a criação da imagem, como por exemplo, realizar a compactação da mesma. Exemplo:
  
  ```
   "post-processors": [
      [
        {
          "type": "artifice",
          "files": ["consul"]
        },
        {
          "type": "compress",
          "output": "consul-0.5.2.tar.gz"
        },
        {
          "type": "shell-local",
          "inline": [
            "/usr/local/bin/aws s3 cp consul-0.5.2.tar.gz s3://<s3 path>"
          ]
        }
      ]
    ]
  ```

- **Variables:** permite definir variáveis, tornando o *template* flexível. Estas podem ser utilizadas nas diferentes partes do *template*;

- **Sources:** definir as fontes que o *Packer* utiliza para criar as imagens. Pode ser útil para criar múltiplas imagens com configurações semelhantes. Exemplo:
  
  ```
  source "null" "example1" {
    communicator = "none"
  }
  
  source "null" "example2" {
    communicator = "none"
  }
  
  build {
    sources = ["source.null.example1", "source.null.example2"]
    provisioner "shell-local" {
      inline = ["echo not overridden"]
      override = {
        example1 = {
          inline = ["echo yes overridden"]
        }
      }
    }
  }
  ```

- **Plugins:** estendem a funcionalidade do *Packer*. Estes permitem que o processo de *build* das imagens seja adaptado conforme a necessidade, realizando tarefas adicionais que estendem as funcionalidades nativas do *Packer*. Já existem um conjunto extenso de *Plugins* desenvolvidos pela comunidade. Exemplo da utilização do *plugin* "happycloud":
  
  ```
  packer {
    required_plugins {
      happycloud = {
        version = ">= 2.7.0"
        source = "github.com/hashicorp/happycloud"
      }
    }
  }
  ```
  
  Caso esta secção esteja presente, é necessário instalar o *plugin*, podendo-se, por exemplo, utilizar o comando *packer init*, que realiza uma listagem de todos os *plugins* instalados e instala a verão mais recente tendo em conta a restrição especificada no bloco *required_plugins*;

- Existem ainda mais configurações que não serão detalhadas no contexto do presente trabalho. Uma configuração interessante de se referir consiste nos ficheiros *preseed.cnf*. Este permite definir as respostas necessárias para automatizar o processo de instalação da imagem, variando de acordo com o sistema operativo. Abaixo encontra-se um exemplo da sintaxe do mesmo.
  
  ```
  d-i debian-installer/locale string en_US
  d-i netcfg/get_hostname string debian
  d-i netcfg/get_domain string exemplo.com
  d-i passwd/user-fullname string User teste
  d-i passwd/username string teste
  d-i passwd/user-password password password
  d-i passwd/user-password-again password passworde-policy select none
  d-i pkgsel/upgrade select full-upgrade
  ```
  
  No ficheiro de configuração (*template*) é necessário referenciar este ficheiro.

### Vantagens do Packer

Tendo em conta o referido anteriormente, o *Packer* possui claramente algumas características interessantes:

- **Portabilidade:** permite criar imagens idênticas para várias plataformas, reduzindo assim problemas de compatibilidade;

- **Estabilidade**: toda a instalação e configuração do *software* é realizada na construção da imagem. Caso existam problemas nos ficheiros de configuração serão detetados previamente, evitando que sejam criadas máquinas com erros;

- **Testabilidade**: após o *build* da máquina, a sua imagem pode ser rapidamente lançada e testada para verificar que tudo está funcional. Isto fornece confiança que outras máquinas lançadas a partir dessa mesma imagem funcionarão como esperado;

- **Integração com outras ferramentas:** este permite ser integrado com ferramentas como o *Chef* ou o *Puppet*, auxiliando no processo de instação e configuração do *software* dentro das imagens criadas, simplificando assim a automação;

- **Rápida implantação de infraestrutura:** as imagens do *Packer* permitem que sejam lançadas máquinas já configuradas em segundos ou poucos minutos. Isto aumenta, claramente, a eficiência para quem utiliza esta ferramenta;

#### Como o Packer se compara com o Terraform e o Vagrant

Nesta secção são detalhadas as principais diferenças/semelhanças entre o *Terraform*, o *Vagrant* e o *Packer*.

**Nota:** todas estas ferramentas pertencem à empresa *HashiCorp*.

As três ferramentas têm propósitos diferentes, no entanto estas podem ser utilizadas em conjunto para criar, realizar o *provision* e gerenciar ambientes de forma eficiente.

##### Packer

Tal como já mencionado, o *Packer* permite a criação de imagens de máquinas, automatizando o processo de *build* de imagens pré-configuradas para diferentes plataformas.

##### Vagrant

O *Vagrant* permite a criação e configuração de ambientes de desenvolvimento, simplificando o processo de gestão de máquinas virtuais locais. Isto permite que seja facilmente definido um ambiente de testes, por exemplo.

###### Como funciona o Vagrant

Em suma, o *vagrant* utiliza um *vagrantfile* que define a configuração da máquina (sistema operativo, pacotes a instalar, configurações de rede, entre outros). Com o *vagrantfile* definido pode-se utilizar o comando *vagrant up* de forma a criar a máquina virtual. Após terminado o desenvolvimento, pode-se utilizar o comando *vagrant destroy* para remover a máquina criada anteriormente.

###### Principais características

- **Suporta Múltiplos Provedores**: este suporta múltiplos provedores de virtualização, como por exemplo, o VirtualBox, o VMware, entre outros;

- **Simplicidade:** com poucos comandos é possível criar/destruir máquinas virtuais, facilitando ambientes de desenvolvimento;

- **Automatização de instalação e configuração:** podem-se utilizar *provisioners* como a *Shell* para que o processo de instação e configuração seja automático;

- **Ambientes Uniformes:** permite que diferentes pessoas utilizem um ambiente idêntico a nível de configurações, reduzindo problemas de compatibilidade;

##### Terraform

O *terraform* corresponde a uma ferramenta de *Infrastructure as Code* (IaC). Este facilita a implantação e a gestão de uma infraestrutura, tanto em ambientes locais quanto na nuvem. Além disso, pode ser facilmente estendido com *plugins*.

###### Como funciona o Terraform

Este é divido principalmente em três etapas:

1. **Write (escrita):** nesta etapa são definidos os recursos que se pretende implantar utilizando ficheiros de extensão *HCL*;

2. **Plan (planear):** após escrita a configuração, o *terraform* cria um plano de execução e descreve quais as ações que serão executadas para criar, atualizar ou destruir a infraestrutura. Este mostra que alterações serão efetuadas, permitindo revê-las e aprová-las antes de serem aplicadas;

3. **Apply (aplicar):** o *terraform* executa as operações propostas numa certa ordem, respeitando as dependências entre os recursos;

###### Principais características

- **Configurações uniformes:** o *terraform* suporta a reutilização de componentes de configuração chamados *modules* que definem coleções de infraestrutura configuráveis, economizando tempo. Podem ser utilizados módulos públicos do **Terraform Registry ([https://registry.terraform.io/](https://registry.terraform.io/))** ou podem ser criados os próprios modulos;

- **Suporta múltiplos provedores:** é possível encontrar uma grande quantidade de provedores no **Terraform Registry**. Também é possível criar os próprios provedores caso necessário. Este segue uma abordagem de imutabilidade na infraestrutura, simplificando o processo de atualização e/ou modificação dos serviços utilizados;

- **Rastreamento da Infraestrutura:** como já mencionado este gera um plano antes de realizar alterações à infraestrutura que só é executado com uma aprovação. Para além disso, este mantém um ficheiro que rastreia o estado da infraestrutura, permitindo que o *terraform* determine que mudanças realizar à infraestrutura para que a mesma corresponda à definida na configuração;

- **Automação de Alterações:** não é necessário escrever o passo a passo detalhado para a criação de recursos, apenas a descrição da infraestrutura final, sendo que o *terraform* responsabiliza-se por todo o processo até se antigir esse estado. Este cria um gráfico de dependências entre os recursos e com base nesse gráfico determina a ordem que os recursos devem ser criados/modificados. Para além disso, se existirem recursos que não dependam entre si, o *terraform* realiza a criação desses mesmo recursos em paralelo, aumentando a eficiência de todo o processo.

É de realçar que estas ferramentas podem ser interligadas entre si, ou seja, o *Terraform* pode utilizar imagens estáveis criadas pelo *Packer* e testadas pelo *Vagrant* de forma a implantar recursos de infraestrutura em servidores físicos ou na *cloud*, garantindo-se um correto funcionamento desde a fase do desenvolvimento até à fase de produção.

##### Considerações finais

Das três opções escolhidas, o *Vagrant* é claramente a ferramenta indicada no contexto do presente trabalho. No entanto, é possível utilizar uma das outras ferramentas (com algumas adaptações) para realizar algo semelhante ao que o *Vagrant* possibilita.

Escolheu-se o *Packer* dado que os objetivos pretendidos podem ser mais facilmente alcançados utilizando esta ferramenta quando comparada com o *Terraform*.

#### Implementação do CA3 com o Packer

Todo este processo teve como base a própria documentação do *Packer*.

##### Passo 1 - Instalar o *Packer*

Para instalar o *Packer* começou-se por descarregar o mesmo da documentação oficial ([Install | Packer | HashiCorp Developer](https://developer.hashicorp.com/packer/install?product_intent=packer)), tendo-se descarrega um ficheiro *zip*. De seguida, extraiu-se este ficheiro, colocou-se num local à escolha e adicionou-se esse mesmo local à variável de sistema **PATH**. Por fim, executou-se o comando packer na consola de forma a verificar que o mesmo tinha sido corretamento instalado.

##### Passo 2 - Criação da Estrutura de Ficheiros

Começou-se por criar um ficheiro com a extensão *.pkr.hcl* que foi posteriormente utilizado para realizar a *build* com a ferramenta.

Para além disso, também foi criado um diretório de *scripts* e um diretório *http* no qual se adicionou uma *preseed*.

##### Passo 3 - Explicação dos scripts criados e do ficheiro de configuração

No ficheiro de configuração *.hcl* começou-se por adicionar um conjunto de variáveis para poderem ser utilizadas em todo o ficheiro.
De seguida, foi adicionada uma secção *source* para ser posteriormente utilizada pela secção *build*:

```
source "virtualbox-iso" "CA3" {
  boot_command            = [
    "<esc><esc><enter><wait>", 
    "/install/vmlinuz noapic ", 
    "initrd=/install/initrd.gz ", 
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed} ", 
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ", 
    "hostname=${var.hostname} ", 
    "grub-installer/bootdev=/dev/sda<wait> ", 
    "fb=false debconf/frontend=noninteractive ", 
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ", 
    "keyboard-configuration/variant=USA console-setup/ask_detect=false ", 
    "passwd/user-fullname=${var.ssh_fullname} ", 
    "passwd/user-password=${var.ssh_password} ", 
    "passwd/user-password-again=${var.ssh_password} ", 
    "passwd/username=${var.ssh_username} ", "-- <enter>"
  ]
  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "http"
  keep_registered         = "true"
  skip_export             = "true"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_path}/${var.iso_name}", 
    "${var.iso_url}"
  ]
  iso_target_path    = "/tmp/ubuntu-18.04.6-server-amd64.iso"
  output_directory        = "output"
  shutdown_command        = "echo 'A máquina não será desligada' && sleep 10"
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"], 
    ["modifyvm", "{{ .Name }}", "--vram", "12"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"], 
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    ["modifyvm", "{{ .Name }}", "--nic1", "bridged"],  
    ["modifyvm", "{{ .Name }}", "--bridgeadapter1", "Intel(R) Wi-Fi 6 AX200 160MHz"]
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
}
```

Esta começa por especificar o tipo de *build* (podem ser de três tipos diferentes para o virtualbox), escolhendo-se neste caso o tipo *virtualbox-iso*, bem como o nome *CA3*. Este tipo de *build* permite criar imagens compatíveis com o *virtualbox* através de um ISO.

De seguida, definiu-se um *array boot_comand* que permite especificar uma sequência de comandos para automatizar o processo de instalação do sistema operativo. Também se utilizou um ficheiro *preseed* para auxiliar na configuração/instalação do mesmo.

De seguida, é apresentado o conteúdo desse ficheiro:

```
### Instalação base do sistema
d-i base-installer/kernel/override-image string linux-server

### Configuração da conta
d-i passwd/user-fullname string ubuntu
d-i passwd/username string ubuntu
d-i passwd/user-password password ubuntu
d-i passwd/user-password-again password ubuntu
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

### Configuração do relógio e timezone
d-i clock-setup/utc boolean true
d-i time/zone string UTC

# Configuração de rede
d-i netcfg/choose_interface select auto
d-i netcfg/get_ipaddress string 192.168.56.10  # IP
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string 192.168.56.1  # Gateway da rede
d-i netcfg/get_nameservers string 8.8.8.8, 8.8.4.4
d-i netcfg/disable_dhcp boolean true

### Partições
d-i partman-auto/method string lvm
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto-lvm/guided_size string max
d-i partman/choose_partition select finish
d-i partman/confirm_nooverwrite boolean true

d-i mirror/http/proxy string

### Seleção dos pacotes
tasksel tasksel/first multiselect standard
d-i pkgsel/update-policy select none
d-i pkgsel/include string openssh-server
d-i pkgsel/install-language-support boolean false

### Instalação do bootloader
d-i grub-installer/only_debian boolean true

### Finalização da instalação
d-i finish-install/reboot_in_progress note
```

Este ficheiro, juntamente com os comandos mencionados anteriormente, permitem que o processo de instalação da máquina virtual ocorra sem interação do utilizador, sendo automaticamente instalada e configurada.

Na secção seguinte definiu-se o tamanho do disco (utilizando a variável definida previamente) e o tipo do sistema operativo.

Para além disso, também se definiram as opções *keep_registered* e *skip_export* para que a máquina não fosse apagada no final do *build*, bem como para não exportar a máquina criada.

O *shutdown_command* teve de ser definido dado que, caso este não seja definido o *packer* elimina a máquina virtual gerada automaticamente.

Seguidamente definiu-se o *iso_checksum*, o *iso_urls* e o *iso_target_path*:

1. O *iso_urls* define o endereço para descarregar o ficheiro ISO (também se poderia apontar para um ficheiro local);

2. O *iso_checksum* é utilizado para verificar a integridade do ficheiro;

3. O *iso_target_path* define o caminho onde o ficheiro ISO será guardado na máquina virtual;

De seguida, definiu-se o *output_directory* que especifica o diretório no qual os ficheiros da VM serão armazenados quando esta é criada.

Após isto, definiram-se o *ssh_username* e o *ssh_password* que são as credencias utilizadas pelo *Packer* para realizar o *ssh* à VM durante a fase da configuração da mesma. Também foi definido o *shutdown_command* que define como a máquina virtual será desligada após o *Packer* completar a instalação.

Na secção do *vboxmanage* foram passados um conjunto de configurações adicionais da máquina virtual para o VirtualBox (como, por exemplo, a memória, o número de CPU's, entre outras).

Foi também adicionada uma secção *build* ao ficheiro de configuração. Esta define como é que a imagem será construida, utilizando, por norma, várias etapas:

```
build {
  sources = ["source.virtualbox-iso.CA3"]

  # Copiar a chave pública SSH para a VM
  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519.pub"
    destination = "/home/ubuntu/authorized_keys"
  }

  # Copiar a chave privada SSH para a VM
  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519"  # Caminho para a chave no host
    destination = "/home/ubuntu/id_ed25519"  # Caminho de destino na VM
  }

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=${var.update}", 
      "SSH_USERNAME=${var.ssh_username}", 
      "SSH_PASSWORD=${var.ssh_password}", 
      "http_proxy=${var.http_proxy}", 
      "https_proxy=${var.https_proxy}", 
      "no_proxy=${var.no_proxy}",
      "VM_NAME=${var.vm_name}",
    ]
    execute_command   = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh", 
      "script/cleanup.sh",
      "script/provision.sh",
    ]
  }
```

Em suma, está-se a copiar chaves SSH para a máquina virtual e executar um conjunto de *scripts* adicionais. A chaves *SSH* são copiadas de forma a realizar o *clone* do repositório descrito no **passo 5**. Como já mencionado, são também executados um conjunto de *scripts*. Como estes dependem de certas variáveis, estas são passadas para os mesmos através das *environment_vars*.

Foram criados três *scripts*:

- **Update:** este realiza um conjunto de comandos, principalmente relacionados com a instalação de pacotes;

- **Clean:** realiza um conjunto de comandos com o intuíto de reduzir o tamanho da imagem de disco e remove informações não necessárias na distribuição final (este *script* foi retirado de um repositório encontrado);

- **Provision**: todos os restantes passos que serão detalhados nos passos posteriores;

##### Passo 4 - Instalação das dependências necessárias

Para instalar as dependências necessárias para realizar o *clone* e a execução dos projetos, foi adicionado ao ficheiro *update.sh* o seguinte conteúdo:

```
# Instala os pacotes necessários
echo "<=============>A atualizar a lista de repositórios...<=============>"

apt-get -y update
if [[ $UPDATE =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    apt-get -y dist-upgrade
fi
apt-get -y install --no-install-recommends build-essential ...
... linux-headers-generic
apt-get -y install --no-install-recommends ssh nfs-common ...
... vim curl git openjdk-17-jdk
```

Este realiza um *apt-get update* de forma a garantir que tudo está atualizado e também instala os pactos *vim*, *curl*, *git* e *openjdk-17-jdk*. Sendo estes dois últimos necessários para a execução dos próximos passos.

##### Passo 5 - Clone do Repositório na Máquina Virtual

De forma a realizar o *clone* do repositório foi adicionado ao *script* de *provision* o seguinte conteúdo:

```
mkdir -p /home/ubuntu/.ssh
mv /home/ubuntu/authorized_keys /home/ubuntu/.ssh
mv /home/ubuntu/id_ed25519 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/id_ed25519
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

echo 'Host github.com' >> /etc/ssh/ssh_config
echo '    IdentityFile /home/ubuntu/.ssh/id_ed25519' >> /etc/ssh/ssh_config
echo '    User git' >> /etc/ssh/ssh_config

ssh-keyscan github.com >> /home/ubuntu/.ssh/known_hosts

sudo -u ubuntu git clone git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git /home/ubuntu/repositorio

service ssh restart
```

1. Começa-se por criar um diretório *.ssh* na *home* do utilizador *ubuntu* (é sempre utilizado este utilizador no contexto do trabalho);

2. Move-se as chaves *ssh* (copiadas anteriormente para a máquina virtual, na secção de *build* do ficheiro de configuração) para a pasta criada;

3. Alteram-se as permissões da chave *ssh*, bem como do diretório *.ssh*, tornando-o mais seguro;

4. Ativa-se a autenticação por chave pública no serviço de *ssh*;

5. Adiciona-se uma configuração para que o *GitHub* utilize a chave *id_ed25519* ao se conectar com o *git*;

6. Adiciona-se a chave do servidor do *GitHub* aos *known_hosts* de forma a que o sistema confie no *GitHub* e não seja pedida uma confirmação ao conectar-se;

7. Realiza-se o *clone* do repositório para uma pasta;

##### Passo 6 - Interagir com Ambas as Aplicações Através do Host

De forma a interagir com as aplicações na máquina *host*, foi necessário configurar o *port forwarding*. Para isso alterou-se o ficheiro de configuração, adicionando-se o seguinte conteúdo à secção *vboxmanage*:

```
["modifyvm", "{{ .Name }}", "--natpf1", "guestport8080,tcp,,8080,,8080"], 
["modifyvm", "{{ .Name }}", "--natpf1", "guestport59001,tcp,,59001,,59001"]
```

Isto permitiu realizar o *forwarding* da máquina virtual para o *host*. Com isto configurado, executou-se os projetos pretendidos e acedeu-se aos mesmos através do *host*. Por exemplo, para o caso do *tut-rest*, correu-se o *maven wrapper* do *CA1* e de seguida acedeu-se ao url *http://{ip_máquina_virtual}:8080/employees* para verificar que o *port-forwarding* foi executado com sucesso.

Para a aplicação de *chat* realizou-se algo semelhante, mas executando-se o cliente na máquina *host*.

![alt text](tut-rest.png "Tut-Rest")

##### Passo 7 - Automatização do clone, build e inicialização das aplicações

Em relação à automatização do *clone*, a mesma já foi detalhada no passo 5.

Em relação ao *build* e *inicialização*, como se utiliza um *gradle wrapper* este passo pode ser executado com um só comando. Adicionou-se um novo *provisioner* que executa no fim de todos os outros com o seguinte conteúdo de forma a executar, por exemplo, o *tut-rest*:

```
 {
      "type": "shell",
      "inline": [
        "cd {{user `repositorio/CA2/tutRestGradle/norest`}} && ../gradlew bootRun"
      ],
  },
```

##### Passo 8 - Garantir que a VM Retém os Dados Quando Reinciada

Não foi possível realizar este passo dado que não se encontrou qualquer informação sobre como fazer isto com esta ferramenta.

##### Passo 9 - Criação das duas máquinas virtuais

Para este efeito foi criado um outro ficheiro de configuração, mas que executa as duas máquinas virtuais. Este ficheiro é semelhante ao demonstrado anteriormente com algumas alterações:

```
variable "vm_name_1" {
  type    = string
  default = "server"
}

variable "vm_name_2" {
  type    = string
  default = "h2"
}
```

Definiram-se duas variáveis para os nomes das duas máquinas.

De seguida, foram definidos dois *sources* um para cada uma das máquinas (iguais, moficando-se apenas o nome utilizado). Seguidamente, na secção de *build* foram definidas as duas *sources* e as respetivas *provisions*, utilizando-se o atributo *only* para definir onde é que a *provision* seria executada.

```
source "virtualbox-iso" "CA3" {
  ...
  vm_name                 = "${var.vm_name_1}"
  ...
}

source "virtualbox-iso" "CA3-h2" {
  ...
  vm_name                 = "${var.vm_name_2}"
  ...
}

build {
  sources = [
    "source.virtualbox-iso.CA3",
    "source.virtualbox-iso.CA3-h2"
  ]

  # Primeira VM
  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519.pub"
    destination = "/home/ubuntu/authorized_keys"
    only        = ["source.virtualbox-iso.CA3"]
  }

  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519"  # Caminho para a chave no host
    destination = "/home/ubuntu/id_ed25519"  # Caminho de destino no VM
    only        = ["source.virtualbox-iso.CA3"]
  }

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=${var.update}", 
      "SSH_USERNAME=${var.ssh_username}", 
      "SSH_PASSWORD=${var.ssh_password}", 
      "http_proxy=${var.http_proxy}", 
      "https_proxy=${var.https_proxy}", 
      "no_proxy=${var.no_proxy}",
      "VM_NAME=${var.vm_name_1}",
    ]
    execute_command   = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh", 
      "script/cleanup.sh",
      "script/provision.sh",
    ]
    only              = ["source.virtualbox-iso.CA3"]
  }

  # Segunda VM
  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519.pub"
    destination = "/home/ubuntu/authorized_keys"
    only        = ["source.virtualbox-iso.CA3-h2"]
  }

  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519"  # Caminho para a chave no host
    destination = "/home/ubuntu/id_ed25519"  # Caminho de destino no VM
    only        = ["source.virtualbox-iso.CA3-h2"]
  }

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=${var.update}", 
      "SSH_USERNAME=${var.ssh_username}", 
      "SSH_PASSWORD=${var.ssh_password}", 
      "http_proxy=${var.http_proxy}", 
      "https_proxy=${var.https_proxy}", 
      "no_proxy=${var.no_proxy}",
      "VM_NAME=${var.vm_name_2}",
    ]
    execute_command   = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh", 
      "script/cleanup.sh",
      "script/provision.sh",
    ]
    only              = ["source.virtualbox-iso.CA3-h2"]
  }
}
```

Não foi possível fazer com que a execução da aplicação *Spring Boot* espera-se pela base de dados estar pronta dado que ao contrário do Vagrant não foi encontrada uma forma de executar uma determinada *provision* sobre uma máquina virtual que já se encontra-se a correr.

##### Passo 10 - Garantir que as VM's possuem recursos alocados suficientes

Tal como já referido, pode-se adicionar o seguinte conteúdo ao ficheiro de configuração. Este permite configurar a máquina virtual com um determinado número de cpus, de memória, entre outros aspetos:

```
vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"], 
    ["modifyvm", "{{ .Name }}", "--vram", "12"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"], 
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    ["modifyvm", "{{ .Name }}", "--nic1", "bridged"],  
    ["modifyvm", "{{ .Name }}", "--bridgeadapter1", "Intel(R) Wi-Fi 6 AX200 160MHz"]
  ]
```

##### Passo 11 - Garantir que possuimos chaves SSH customizadas para acesso seguro

Já foi demonstrado no passo 5.

##### Passo 12 - Tornar a máquina virtual da DB só acessível pela máquina virtual da VM

Este passo não foi efetuado dado que tivemos alguma dificuldade no acesso por *ssh* após a definição de endereços de IP estáticos. No entanto a sugestão seria a criação de um outro *script* que seria executado na *build* que gera máquina do servidor e que teria o seguinte conteúdo:

```
#!/bin/bash

# Instalação dos pacotes
sudo apt update
sudo apt install -y ufw

sudo ufw allow ssh

sudo ufw --force enable

# Permitir conexões na porta 9092 da vm do servidor
sudo ufw allow from "$APP_VM_IP" to any port 9092

# Recusar todas as outras conexões
sudo ufw deny 9092
```

#### Dificuldades encontradas

Inicialmente a ferramenta escolhida foi o *Terraform*. No entanto, encontrou-se dificuldades de integração da mesma com o *VirtualBox*, existindo pouca informação disponível. A maior dificuldade passou pela máquina executar o *shutdown* após a sua criação, não executando o *provision* fornecido. Experimentou-se com diferentes versões, mas sem sucesso.
