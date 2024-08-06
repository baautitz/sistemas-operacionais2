# Solicitar ao usuário o nome do processo
$ProcessName = Read-Host "Por favor, forneça o nome do processo"

if (-not $ProcessName) {
    Write-Host "Nome do processo não fornecido. Encerrando o script."
    exit 1
}

# Obter os processos com o nome fornecido
$processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue

if ($processes) {
    # Matar cada processo encontrado
    foreach ($process in $processes) {
        try {
            $process.Kill()
            $saida = "Processo '$($process.Name)' com ID $($process.Id) foi finalizado."

            if (!(Test-Path .\resultado.txt)) {
                Out-File -FilePath .\resultado.txt
            }

            $saida | Add-Content -Path .\resultado.txt
            Write-Host $saida

        } catch {
            Write-Host "Erro ao tentar finalizar o processo '$($process.Name)' com ID $($process.Id): $_"
        }
    }
} else {
    Write-Host "Nenhum processo encontrado com o nome '$ProcessName'."
}
    