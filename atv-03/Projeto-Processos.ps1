$caminhoArquivoLog = ".\resultado.txt"
if (!(Test-Path $caminhoArquivoLog)) {
    New-Item -Path $caminhoArquivoLog -ItemType File | Out-Null
    Write-Host "Arquivo de log criado em: $caminhoArquivoLog"
}
else {
    Write-Host "Arquivo de log já existe: $caminhoArquivoLog"
}

while ($true) {
    Write-Host "======================= MENU ======================="
    Write-Host "|                                                  |"
    Write-Host "|            1 - Finalizar processos               |"
    Write-Host "|            2 - Listar logs                       |"
    Write-Host "|            3 - Iniciar 'Bloco de Notas'          |"
    Write-Host "|            4 - Lixeira                           |"
    Write-Host "|            0 - Sair                              |"
    Write-Host "|                                                  |"
    Write-Host "===================================================="
    $opcao = Read-Host "Escolha uma opção"

    if ($opcao -eq 1) {
        $nomeProcesso = Read-Host "Por favor, forneça o nome do processo"

        if (-not $nomeProcesso) {
            $saida = "Nome do processo não fornecido. Encerrando o script."

            Add-Content -Path $caminhoArquivoLog -Value $saida
            Write-Host $saida
            
            Continue
        }

        $processos = Get-Process -Name $nomeProcesso -ErrorAction SilentlyContinue

        if ($processos) {
            foreach ($processo in $processos) {
                try {
                    $processo.Kill()

                    $saida = "Processo '$($processo.Name)' com ID $($processo.Id) foi finalizado."
                    
                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida
                }
                catch {
                    $saida = "Erro ao tentar finalizar o processo '$($processo.Name)' com ID $($processo.Id): $_"
                    
                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida
                }
            }
        }
        else {
            $saida = "Nenhum processo encontrado com o nome '$ProcessName'."
            
            Add-Content -Path $caminhoArquivoLog -Value $saida
            Write-Host $saida
        }

        Pause
    }
    elseif ($opcao -eq 2) {
        Get-Content -Path $caminhoArquivoLog
        
        Pause
    }
    elseif ($opcao -eq 3) {
        Start-Process -FilePath "notepad.exe"

        $saida = "Processo 'Notepad' foi iniciado."
        Add-Content -Path $caminhoArquivoLog -Value $saida
        Write-Host $saida

        Pause
    }
    elseif ($opcao -eq 4) {
        $caminhoArquivos = ".\arquivos"
        $caminhoLixeira = ".\lixeira"

        # Testa se diretório de arquivos existe
        if (!(Test-Path $caminhoArquivos)) {
            New-Item -Path $caminhoArquivos -ItemType Directory | Out-Null

            $saida = "Diretório de arquivos criado em: $caminhoArquivos"

            Add-Content -Path $caminhoArquivoLog -Value $saida
            Write-Host $saida 
        }
        else {
            $saida = "Diretório de arquivos já existe: $caminhoArquivos"

            Add-Content -Path $caminhoArquivoLog -Value $saida
            Write-Host $saida 
        }

        # Testa se diretório lixeira existe
        if (!(Test-Path $caminhoLixeira)) {
            New-Item -Path $caminhoLixeira -ItemType Directory | Out-Null

            $saida = "Diretório lixeira criado em: $caminhoLixeira"

            Add-Content -Path $caminhoArquivoLog -Value $saida
            Write-Host $saida 
        }
        else {
            $saida = "Diretório lixeira já existe: $caminhoLixeira"

            Add-Content -Path $caminhoArquivoLog -Value $saida
            Write-Host $saida 
        }

        while ($true) {
            Write-Host "============================== LIXEIRA ============================="
            Write-Host "|                                                                  |"
            Write-Host "|           1 - Mover para lixeira                                 |"
            Write-Host "|           2 - Mostrar conteúdo da lixeira                        |"
            Write-Host "|           3 - Remover da lixeira                                 |"
            Write-Host "|           4 - Restaurar para diretório de origem                 |"
            Write-Host "|           5 - Criar arquivo vazio                                |"
            Write-Host "|           0 - Sair                                               |"
            Write-Host "|                                                                  |"
            Write-Host "===================================================================="
            $opcaoLixeira = Read-Host "Escolha uma opção"

            if ($opcaoLixeira -eq 1) {
                $nomeArquivo = Read-Host "Digite o nome do arquivo (com a extensão)"

                if (!(Test-Path ".\$caminhoArquivos\$nomeArquivo")) {
                    $saida = "Arquivo '$nomeArquivo' não encontrado."

                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida 

                    Pause
                    Continue
                }

                Move-Item -Path ".\$caminhoArquivos\$nomeArquivo" -Destination ".\$caminhoLixeira\$nomeArquivo.lix"

                $saida = "Arquivo '$nomeArquivo' movido para lixeira."

                Add-Content -Path $caminhoArquivoLog -Value $saida
                Write-Host $saida 

                Pause
            }
            elseif ($opcaoLixeira -eq 2) {
                $resultadoListagemArquivos = Get-ChildItem -Path ".\$caminhoLixeira" -Name

                if (($resultadoListagemArquivos | Measure-Object -Word).Words -eq 0) {
                    $saida = "Não há nenhum arquivo na lixeira."

                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida 
                }
                else {
                    Write-Host $resultadoListagemArquivos
                }

                Pause
            }
            elseif ($opcaoLixeira -eq 3) {
                $nomeArquivo = Read-Host "Digite o nome do arquivo (com a extensão)"

                if (!(Test-Path ".\$caminhoLixeira\$nomeArquivo.lix")) {
                    $saida = "Arquivo '$nomeArquivo' não encontrado."

                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida 

                    Pause
                    Continue
                }

                Remove-item -Path ".\$caminhoLixeira\$nomeArquivo.lix" -Confirm

                $saida = "Arquivo '$nomeArquivo' removido da lixeira."

                Add-Content -Path $caminhoArquivoLog -Value $saida
                Write-Host $saida 

                Pause
            }
            elseif ($opcaoLixeira -eq 4) {
                $nomeArquivo = Read-Host "Digite o nome do arquivo (com a extensão)"

                if (!(Test-Path ".\$caminhoLixeira\$nomeArquivo.lix")) {
                    $saida = "Arquivo '$nomeArquivo' não encontrado."

                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida 

                    Pause
                    Continue
                }

                Move-Item -Path ".\$caminhoLixeira\$nomeArquivo.lix" -Destination ".\$caminhoArquivos\$nomeArquivo"

                $saida = "Arquivo '$nomeArquivo' restaurado da lixeira."

                Add-Content -Path $caminhoArquivoLog -Value $saida
                Write-Host $saida 

                Pause
            }
            elseif ($opcaoLixeira -eq 5) {
                $nomeArquivo = Read-Host "Digite o nome do arquivo (com a extensão)"

                if (Test-Path ".\$caminhoArquivos\$nomeArquivo") {
                    $saida = "Arquivo '$nomeArquivo' já existe."

                    Add-Content -Path $caminhoArquivoLog -Value $saida
                    Write-Host $saida 

                    Pause
                    Continue
                }

                New-Item -Path ".\$caminhoArquivos\$nomeArquivo" -ItemType File | Out-Null
            }
            
            else {
                Break
            }
        }
    }
    else {
        Break
    }
}