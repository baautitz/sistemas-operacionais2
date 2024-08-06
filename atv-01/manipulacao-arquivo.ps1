'Linha 1', 'Linha 2', 'Linha 3' | Out-File -FilePath .\arquivo.txt

Write-Host "`nDuas maneiras de retornar a primeira linha:"
Get-Content -Path .\arquivo.txt | Select-Object -First 1 
(Get-Content -Path .\arquivo.txt)[0]

Write-Host "`nDuas maneiras de retornar a última linha:"
Get-Content -Path .\arquivo.txt | Select-Object -Last 1 
(Get-Content -Path .\arquivo.txt)[-1]

$linhas = (Get-Content -Path .\arquivo.txt | Measure-Object -Line).Lines
Write-Host "`nContando o número de linhas: $linhas"
