while true
do
    echo "====================== MENU ======================"
    echo "1 - Criar diretório                                "
    echo "2 - Deletar diretório                              "
    echo "3 - Procurar uma string dentro de um arquivo       "
    echo "4 - Lixeira                                        "
    echo "0 - Sair                                           "
    echo "=================================================="
    
    read -p "Escolha uma opção: " op
    
    if ((op == 1))
    then
        read -p "Digite o nome do diretório: " dir_name
        if [[ ! "$dir_name" ]]
        then
            echo "Digite um nome válido."
            continue
        fi
        
        if [ -d "$dir_name" ]
        then
            echo "Diretório '$dir_name' já existe."
            continue
        fi
        
        mkdir "$dir_name"
        echo "Diretório '$dir_name' criado com sucesso!"
    elif ((op == 2))
    then
        read -p "Digite o nome do diretório: " dir_name
        if [[ ! "$dir_name" ]]
        then
            echo "Digite um nome válido."
            continue
        fi
        
        if [ ! -d "$dir_name" ]
        then
            echo "Diretório '$dir_name' não encontrado."
            continue
        fi
        
        rmdir "$dir_name"
        echo "Diretório '$dir_name' deletado com sucesso!"
    elif ((op == 3))
    then
        read -p "Digite o nome do arquivo: " file_name
        if [[ ! -f "$file_name" ]]
        then
            echo "Arquivo '$file_name' não encontrado."
            continue
        fi
        
        read -p "Digite a string a ser procurada: " search_string
        grep -i "$search_string" "$file_name"
        if (( $? == 0 ))
        then
            echo "String '$search_string' encontrada no arquivo '$file_name'."
        else
            echo "String '$search_string' não encontrada no arquivo '$file_name'."
        fi
    elif ((op == 4))
    then
        lixeira_dir="./lixeira"
        arquivos_dir="./arquivos"
        
        mkdir -p "$lixeira_dir" "$arquivos_dir"
        
        while true
        do
            echo "============================== LIXEIRA ============================="
            echo "1 - Mover para lixeira                                              "
            echo "2 - Mostrar conteúdo da lixeira                                     "
            echo "3 - Remover da lixeira                                              "
            echo "4 - Restaurar para diretório de origem                              "
            echo "5 - Criar arquivo vazio                                             "
            echo "0 - Sair                                                            "
            echo "===================================================================="
            
            read -p "Escolha uma opção: " opcao_lixeira
            
            if ((opcao_lixeira == 1))
            then
                read -p "Digite o nome do arquivo (com a extensão): " nome_arquivo
                if [[ ! -f "$arquivos_dir/$nome_arquivo" ]]
                then
                    echo "Arquivo '$nome_arquivo' não encontrado."
                    continue
                fi
                
                mv "$arquivos_dir/$nome_arquivo" "$lixeira_dir/$nome_arquivo.lix"
                echo "Arquivo '$nome_arquivo' movido para a lixeira."
            elif ((opcao_lixeira == 2))
            then
                if [[ $(ls -A "$lixeira_dir") ]]
                then
                    ls "$lixeira_dir"
                else
                    echo "Não há nenhum arquivo na lixeira."
                fi
            elif ((opcao_lixeira == 3))
            then
                read -p "Digite o nome do arquivo (com a extensão): " nome_arquivo
                if [[ ! -f "$lixeira_dir/$nome_arquivo.lix" ]]
                then
                    echo "Arquivo '$nome_arquivo' não encontrado."
                    continue
                fi
                
                rm "$lixeira_dir/$nome_arquivo.lix"
                echo "Arquivo '$nome_arquivo' removido da lixeira."
            elif ((opcao_lixeira == 4))
            then
                read -p "Digite o nome do arquivo (com a extensão): " nome_arquivo
                if [[ ! -f "$lixeira_dir/$nome_arquivo.lix" ]]
                then
                    echo "Arquivo '$nome_arquivo' não encontrado."
                    continue
                fi
                
                mv "$lixeira_dir/$nome_arquivo.lix" "$arquivos_dir/$nome_arquivo"
                echo "Arquivo '$nome_arquivo' restaurado da lixeira."
            elif ((opcao_lixeira == 5))
            then
                read -p "Digite o nome do arquivo (com a extensão): " nome_arquivo
                if [[ -f "$arquivos_dir/$nome_arquivo" ]]
                then
                    echo "Arquivo '$nome_arquivo' já existe."
                    continue
                fi
                
                touch "$arquivos_dir/$nome_arquivo"
                echo "Arquivo '$nome_arquivo' criado no diretório de arquivos."
            else
                break
            fi
        done
    else
        break
    fi
done
