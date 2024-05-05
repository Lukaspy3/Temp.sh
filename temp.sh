clear

MINER_PROCESS_NAME='cpuminer'

# Define o nome do arquivo de log
LOG_FILE="LOGS/miner_log_A10s.txt"

while true; do

    # Imprime o cabeçalho
    echo "======================================" | tee -a $LOG_FILE
    echo "MINEIRO: A10s" | tee -a $LOG_FILE
    echo "======================================" | tee -a $LOG_FILE

    # Obtém a temperatura da bateria em graus Celsius
    TEMP=$(termux-battery-status | jq '.temperature')

    # Formata a temperatura com duas casas decimais
    TEMP_FORMATADA=$(printf "%.2f" $TEMP)

    # Obtém o tempo de atividade do sistema
    UPTIME=$(uptime -p)

    # Obtém a porcentagem da bateria
    BATTERY_PERCENTAGE=$(termux-battery-status | jq '.percentage')

    # Obtém o status de carregamento
    CHARGING_STATUS=$(termux-battery-status | jq '.plugged')

    # Obtém a data e hora atual
    CURRENT_DATE_TIME=$(date +"%Y-%m-%d %T")

    # Imprime a temperatura, tempo de atividade e a hora atual
    echo "DATA E HORA: $CURRENT_DATE_TIME" | tee -a $LOG_FILE
    echo "ATIVIDADE: $UPTIME" | tee -a $LOG_FILE
    echo "BATERIA: $BATTERY_PERCENTAGE%" | tee -a $LOG_FILE
    echo "CARREGADOR: $CHARGING_STATUS" | tee -a $LOG_FILE
    echo "TEMPERATURA: $TEMP_FORMATADA °C" | tee -a $LOG_FILE

    # Verifica a faixa de temperatura e imprime o status correspondente
    if (( $(echo "$TEMP >= 20 && $TEMP <= 34" | bc -l) )); then
        STATUS="Frio, bom!"
        echo -e "STATUS: \033[0;32m$STATUS\033[0m"
        echo "STATUS: $STATUS" >> $LOG_FILE
    elif (( $(echo "$TEMP > 34 && $TEMP <= 37" | bc -l) )); then
        STATUS="Morno, preocupante!"
        echo -e "STATUS: \033[0;33m$STATUS\033[0m"
        echo "STATUS: $STATUS" >> $LOG_FILE
    elif (( $(echo "$TEMP > 37 && $TEMP <= 60" | bc -l) )); then
        STATUS="Quente, crítico!"
        echo -e "STATUS: \033[0;31m$STATUS\033[0m"
        echo "STATUS: $STATUS" >> $LOG_FILE
    else
        STATUS="Temperatura fora do intervalo especificado"
        echo "STATUS: $STATUS" >> $LOG_FILE
    fi

    # Verifica a faixa de temperatura e interrompe o processo de mineração se necessário
    if (( $(echo "$TEMP >= 38.50" | bc -l) )); then
        echo "Status: crítico, interrompendo a mineração..." | tee -a $LOG_FILE

        # Obtém o PID do processo de mineração
        MINER_PID=$(pgrep -f $MINER_PROCESS_NAME)

        # Envia um sinal SIGINT para o processo de mineração
        if [ ! -z "$MINER_PID" ]; then
            kill -INT $MINER_PID
            echo "Processo de mineração interrompido." | tee -a $LOG_FILE
        else
            echo "Não foi possível encontrar o processo de mineração." | tee -a $LOG_FILE
        fi

        # Fecha o Ubuntu
        echo "Fechando o Ubuntu..." | tee -a $LOG_FILE
        pkill -f $MINER_PROCESS_NAME

        # Espera 5 minutos
        echo "Esperando 5 minutos para o celular esfriar..." | tee -a $LOG_FILE
        sleep 300

        # Reinicia a mineração
        echo "Tentando reiniciar a mineração..." | tee -a $LOG_FILE
        # Desanexar da sessão atual
        tmux detach

        # Criar uma nova sessão
        tmux
        sleep 5
        exit
    fi
    # Aguarda 5 minutos antes de repetir o loop
    sleep 300

done
