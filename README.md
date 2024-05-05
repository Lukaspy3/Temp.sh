# Código de monitoramento de mineiro cpuminer-multi
## Monitor de temperatura

### COMANDO MINERAR AUTOMATICAMENTE:

> Esse comando faz com que mesmo que o celular seja reiniciado o mineração volte a rodar, ele também abre um servidor ssh para acesso remoto, roda um script de verificação de temperatura e muito mais que aparece no terminal e também é armazenado em formato de LOGS do minerador em um arquivo .txt, que você pode acessar remotamente via s'FTP com o IP do dispositivo. Ele também interrompe a mineração quando o dispositivo ultrapassa os 38.5 °C para a segurança, espera 5 minutos para esfriar e inicia novamente a mineração, isso tem um limite de 10 vezes, quando o dispositivo é reiniciado é zerado. Quando esse limite é alcançado ele apenas não iniciará novamente a mineração por segurança.

---

### PARTE 1
*Configuração do arquivo temp.sh*

- Instale o temp.sh
- Abra com nano temp.sh
- Substitua o nome do minerador
- Saia e salve com CTRL x
- Tornar o script em um executável com:
> chmod +x temp.sh
- você pode executar ele com:
> ./temp.sh

---

### PARTE 2
*Iniciação automática do mineiro*

> nano ~/.bashrc

**Cole o codigo:**

> #define o limite de vezes que a mineracao pode reiniciar de > 10
> tmux
> tmux
> tmux
> tmux
> tmux
> tmux
> tmux
> tmux
> tmux
> tmux
> ./temp.sh & #inicia o script de monitoramento de temperatura
> ./start-ubuntu.sh #starta o ubuntu

### PARTE 3
- antes de tudo instalar o Termux Boot no F-droid
- abrir o termux e...

> pkg install openssh -y
> mkdir .termux
> cd .termux
> mkdir boot
> cd boot
> touch start-ssh
> nano start-ssh

> #!/data/data/com.termux/files/usr/bin/sh
#impede o celular de se hibernar
termus-wake-lock
wait
#inicia o servidor para conectar remotamente
sshd &
wait
#abre o termux em primeiro plano
am start -n com.termux/com.termux.app.TermuxActivity
wait
#atualizacao automatica
apt update -y
wait
apt upgrade -y
wait
#inicia o ubuntu
./start-ubuntu.sh


## Agora Dentro do Ubuntu:

> apt install nano && nano ~/.bashrc

> wait
> cd ./cpuminer-multi
> wait
> ./cpuminer -a yescrypt -o stratum+tcp://yescrypt.sea.mine.zpool.ca:6233 -u MC7csJWNtRrpkky8SChYDdvy2ob8kyN3p1 -p c=LTC -t 8
