#!/bin/bash

# Função para exibir como usar o script
show_usage() {
    echo "Uso: $0 <domínio>"
    echo "Exemplo: $0 exemplo.com"
}

# Verifica se foi fornecido pelo menos um argumento
if [ $# -eq 0 ]; then
    echo "Erro: Nenhum argumento fornecido."
    show_usage
    exit 1
fi

# Verifica se o domínio fornecido não está vazio
if [ -z "$1" ]; then
    echo "Erro: O domínio fornecido está vazio."
    show_usage
    exit 1
fi

# Verifica se o domínio é válido (neste exemplo, um domínio válido deve conter um ponto)
if [[ "$1" != *.* ]]; then
    echo "Erro: O domínio fornecido não é válido."
    show_usage
    exit 1
fi

# Exemplo de uso do domínio fornecido:
domain="$1"
echo "Você forneceu o domínio: $domain"
wget $1

# Use grep com uma regex para filtrar apenas os domínios válidos
output=$(grep -oE '(https?://)?[a-zA-Z0-9.-]+\.[a-z]{2,}(\/\S*)?' index.html | sort -u)

# Filtra apenas os domínios válidos usando uma regex
valid_domains=$(echo "$output" | grep -Eo 'https?://[^/]+')

# Remove "https://" da frente dos URLs
cleaned_domains=$(echo "$valid_domains" | sed 's,^https://,,')

# Mapeamento de domínio para IP
for url in $cleaned_domains; do
    ip=$(host "$url" | awk '/has address/ {print $4}')
    echo "Domínio: $url, IP: $ip"
    
    # Verifica o apontamento reverso
    if [ -n "$ip" ]; then
        ptr_result=$(host "$ip")
        echo "   Apontamento Reverso (PTR):"
        echo "$ptr_result"
    fi
    
    echo  # Linha em branco para separar os resultados
done
