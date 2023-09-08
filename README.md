<h1 align="center">Projeto de Administração de Redes usando Vagrant com 3 VMs</h1>
###### *Aluno: Eric Peterson Kassim Costa*



## Descrição
Este projeto visa criar um ambiente de laboratório de administração de redes utilizando a tecnologia Vagrant para provisionar e gerenciar três máquinas virtuais (VMs) interconectadas, cada uma desempenhando um papel específico em uma rede controlada.

## Configuração das VMs
O ambiente é composto por três VMs, cada uma com um papel específico:

**VM1 - Servidor Web (Privado)**
   - **Sistema Operacional:** Ubuntu Server 20.04 LTS
   - **Endereço IP Privado:** 192.168.50.10
   - **Função:** Servidor Web (Apache)
   - **Pasta Compartilhada:** `/var/www/html` na máquina host compartilhada com `/var/www/html` na VM1.

**VM2 - Servidor de Banco de Dados (Privado)**
   - **Sistema Operacional:** Ubuntu Server 20.04 LTS
   - **Endereço IP Privado:** 192.168.50.11
   - **Função:** Servidor de Banco de Dados (MySQL)

**VM3 - Gateway (Privado DHCP e Pública)**
   - **Sistema Operacional:** Ubuntu Server 20.04 LTS
   - **Endereço IP Privado:** 192.168.50.12
   - **Endereço IP Público (DHCP)**
   - **Função:** Gateway de Rede

 ##VagrantFile
**VM1**
```
    # VM1 (SERVIDOR WEB)
    config.vm.define "vm1" do |vm1|
      	vm1.vm.box = "gusztavvargadr/ubuntu-server"
      	vm1.vm.network "private_network", ip: "192.168.50.10"
      	vm1.vm.provider "virtualbox" do |vb|
      end
      	vm1.vm.synced_folder "share_vm1", "/var/www/html"
      	vm1.vm.provision "shell", path: "provision/p_vm1.sh"
    end
```
**VM2**
```
    # VM2 (BANCO DE DADOS)
    config.vm.define "vm2" do |vm2|
      	vm2.vm.box = "gusztavvargadr/ubuntu-server"
      	vm2.vm.network "private_network", ip: "192.168.50.11"
      	vm2.vm.provider "virtualbox" do |vb|
      end
      	vm2.vm.provision "shell", path: "provision/p_vm2.sh"
    end
```
**VM3**
```
    # VM3 (GATEWAY)
    config.vm.define "vm3" do |vm3|
      	vm3.vm.box = "gusztavvargadr/ubuntu-server"
      	vm3.vm.network "private_network", ip: "192.168.50.12"
      	vm3.vm.network "public_network", type: "dhcp"
      	vm3.vm.provider "virtualbox" do |vb|
      end
      	vm3.vm.provision "shell", path: "provision/p_vm3.sh"
    end
```
## Arquivos de Provisionamento

Para configurar automaticamente as VMs com os serviços e configurações necessárias, este projeto utiliza arquivos de provisionamento em shell para cada VM.

#### provision/p_vm1.sh

Este arquivo de provisionamento é usado para configurar a VM1, que atua como um servidor web. As tarefas realizadas por este script incluem:

- Instalação do servidor web Apache.
- Configuração da pasta compartilhada.

> *Script:*

```
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl enable apache2

sudo rm -rf /var/www/html
sudo ln -fs /vagrant /var/www/html
```

#### provision/p_vm2.sh

Este arquivo de provisionamento é usado para configurar a VM2, que é um servidor de banco de dados. 

- Instalação do servidor de banco de dados e cliente.

> *Script:*

```
sudo apt-get update
sudo apt-get install -y mysql-server
```
#### provision/p_vm3.sh

Este arquivo de provisionamento é usado para configurar a VM3, que atua como um gateway de rede.

- Foi utilizado o comando ***sysctl*** para habilitar o encaminhamento de IP no kernel da VM3.
- Foi configurado o ***iptables*** para realizar a tradução de endereços de origem (MASQUERADE) na interface de saída ***enp0s8*** da VM3. Isso permite que as VMs na rede privada compartilhem o endereço IP público da VM3 para acessar a Internet.

> *Script:*

```
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
```
##Configurações de Rede

### Rede Privada (192.168.50.0/24)

Todas as VMs estão conectadas por uma rede privada na faixa de endereços 192.168.50.0/24. Aqui estão detalhes adicionais:

- **VM1 (192.168.50.10):** A interface de rede eth0 da VM1 está configurada com o endereço IP estático 192.168.50.10, permitindo que outras VMs se comuniquem com ela por meio dessa interface.

- **VM2 (192.168.50.11):** A interface de rede eth0 da VM2 está configurada com o endereço IP estático 192.168.50.11, permitindo a comunicação com outras VMs na mesma rede privada.

- **VM3 (192.168.50.12):** A interface de rede eth0 da VM3 está configurada com o endereço IP estático 192.168.50.12, permitindo a comunicação com outras VMs na rede privada.

### Configuração de Rede da VM3

A VM3 desempenha o de um gateway de rede, proporcionando conectividade à Internet para VM1 e VM2. Para isso, a VM3 possui duas interfaces de rede:

#### eth0: Rede Privada (192.168.50.0/24)

- **Endereço IP Estático:** 192.168.50.12
- **Função:** Interface de rede privada que permite a comunicação com as outras VMs (VM1 e VM2) na rede privada.

#### eth1: Rede Pública (DHCP)

- **Função:** Interface de rede pública configurada para obter um endereço IP através de DHCP.

## Verificação de Conectividade e Serviços
Verificando se os serviços e a conectividade das VMs:

### Verificando Conectividade:
Foi feito o teste de conectividade entre as VMs através dos seguintes métodos:

- **Acessando VM1 e pingando VM2:**
 ```
  vagrant ssh vm1
  ping 192.168.50.11
```

- **Acessando VM2 e pingando VM1:**
 ```
  vagrant ssh vm2
  ping 192.168.50.10
```

- **Acessando VM2 e pingando VM3:**
 ```
  vagrant ssh vm2
  ping 192.168.50.12
```

### Verificando Serviços
Já para a verificação dos serviços, foram utilizados os seguintes métodos:

- **Teste serviço APACHE (VM1)**

```
vagrant ssh vm1
sudo systemctl status apache2
```
>  *O comando systemctl retorna o status do serviço apache.*

- **Teste serviço MySQL (VM2)**

```
vagrant ssh vm2
sudo systemctl status mysql
```
>  *O comando systemctl retorna o status do serviço apache.*

- **Teste Gateway/Conectividade a Internet (VM3)**

```
vagrant ssh vm3
ping google.com
curl google.com
```
>  *Ao pingar (ping) ou fazer uma solicitação HTTP (curl) a um site externo, é possível testar a conectividade com a internet da VM3*





