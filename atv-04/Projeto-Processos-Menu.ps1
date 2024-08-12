[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$caminhoArquivoLog = ".\resultado.txt"
if (!(Test-Path $caminhoArquivoLog)) {
    New-Item -Path $caminhoArquivoLog -ItemType File | Out-Null
    Write-Host "Arquivo de log criado em: $caminhoArquivoLog"
}
else {
    Write-Host "Arquivo de log já existe: $caminhoArquivoLog"
}

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

function CreateForm {
    [OutputType([System.Windows.Forms.Form])]

    param (
        [string] $Title,
        [int32] $Height,
        [int32] $Width
    )

    [System.Windows.Forms.Form] $form = New-Object System.Windows.Forms.Form

    $form.Text = $Title
    $form.AutoSize = $true
    $form.Size = New-Object System.Drawing.Size($Width, $Height)
    $form.StartPosition = "CenterScreen"

    return $form
}

function SendLog {
    [OutputType([void])]

    param (
        [string] $Message
    )

    Add-Content -Path $caminhoArquivoLog -Value $Message
    Write-Host $Message
    [System.Windows.Forms.MessageBox]::Show($Message)
}

function KillProcess {
    [OutputType([void])]

    param (
        [string] $ProcessName
    )

    if (-not $ProcessName) {
        $saida = "Nome do processo não fornecido."

        SendLog -Message $saida
        return
    }

    $processos = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue

    if ($processos) {
        $saida = ''
        foreach ($processo in $processos) {
            try {
                $processo.Kill()

                $saida += "Processo '$($processo.Name)' com ID $($processo.Id) foi finalizado.`n"                    
            }
            catch {
                $saida += "Erro ao tentar finalizar o processo '$($processo.Name)' com ID $($processo.Id): $_"                    
            }
        }
        SendLog -Message $saida
    }
    else {
        $saida = "Nenhum processo encontrado com o nome '$ProcessName'."
            
        SendLog -Message $saida
    }
}

function CreateKillProcessForm {
    [OutputType([System.Windows.Forms.Form])]

    [System.Windows.Forms.Form] $frm = CreateForm -Title "Finalizar processos" -Width 500 -Height 300

    [System.Windows.Forms.TableLayoutPanel] $tableLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayout.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayout.ColumnCount = 1

    [System.Windows.Forms.Label] $label_ProcessNameTextBox = New-Object System.Windows.Forms.Label
    $label_ProcessNameTextBox.Text = "Digite o nome do processo:"
    $label_ProcessNameTextBox.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $label_ProcessNameTextBox.AutoSize = $true
    $label_ProcessNameTextBox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $label_ProcessNameTextBox.Anchor = [System.Windows.Forms.AnchorStyles]::None

    [System.Windows.Forms.TextBox] $textBox_ProcessName = New-Object System.Windows.Forms.TextBox
    $textBox_ProcessName.Size = New-Object System.Drawing.Size(300, 35)
    $textBox_ProcessName.Anchor = [System.Windows.Forms.AnchorStyles]::None

    [System.Windows.Forms.Button] $button_KillProcess = New-Object System.Windows.Forms.Button
    $button_KillProcess.Text = "Finalizar!"
    $button_KillProcess.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_KillProcess.Size = New-Object System.Drawing.Size(300, 35)
    $button_KillProcess.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_KillProcess.Tag = @{ TextBox = $textBox_ProcessName }
    $button_KillProcess.Add_Click({ KillProcess -ProcessName $this.Tag.TextBox.Text })

    [System.Windows.Forms.Button] $button_Exit = New-Object System.Windows.Forms.Button
    $button_Exit.Text = "Sair"
    $button_Exit.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_Exit.Size = New-Object System.Drawing.Size(300, 35)
    $button_Exit.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_Exit.Add_Click({
            $frm.Close()
        }.GetNewClosure())

    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout.Controls.Add($label_ProcessNameTextBox)
    $tableLayout.Controls.Add($textBox_ProcessName)
    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout.Controls.Add($button_KillProcess)
    $tableLayout.Controls.Add($button_Exit)
    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))

    $frm.Controls.Add($tableLayout)

    return $frm
}

function MoveToBin {
    [OutputType([void])]

    $fileName = [Microsoft.VisualBasic.Interaction]::InputBox("Digite nome do arquivo (com a extensão):", "", "")

    if (-not $fileName) {
        $saida = "Nome do arquivo não fornecido."

        SendLog -Message $saida
        return
    }

    if (!(Test-Path ".\$caminhoArquivos\$fileName")) {
        $saida = "Arquivo '$fileName' não encontrado."

        SendLog -Message $saida
        return
    }

    Move-Item -Path ".\$caminhoArquivos\$fileName" -Destination ".\$caminhoLixeira\$fileName.lix"

    $saida = "Arquivo '$fileName' movido para lixeira."

    SendLog -Message $saida
}

function RestoreFromBin {
    [OutputType([void])]

    $fileName = [Microsoft.VisualBasic.Interaction]::InputBox("Digite nome do arquivo (com a extensão):", "", "")

    if (-not $fileName) {
        $saida = "Nome do arquivo não fornecido."

        SendLog -Message $saida
        return
    }

    if (!(Test-Path ".\$caminhoLixeira\$fileName.lix")) {
        $saida = "Arquivo '$fileName' não encontrado."

        SendLog -Message $saida

        return
    }

    Move-Item -Path ".\$caminhoLixeira\$fileName.lix" -Destination ".\$caminhoArquivos\$fileName"

    $saida = "Arquivo '$fileName' restaurado da lixeira."

    SendLog -Message $saida
}
function RemoveFromBin {
    [OutputType([void])]

    $fileName = [Microsoft.VisualBasic.Interaction]::InputBox("Digite nome do arquivo (com a extensão):", "", "")

    if (-not $fileName) {
        $saida = "Nome do arquivo não fornecido."

        SendLog -Message $saida
        return
    }

    if (!(Test-Path ".\$caminhoLixeira\$fileName.lix")) {
        $saida = "Arquivo '$fileName' não encontrado."

        SendLog -Message $saida

        return
    }

    Remove-item -Path ".\$caminhoLixeira\$fileName.lix"

    $saida = "Arquivo '$fileName' removido da lixeira."

    SendLog -Message $saida
}

function CreateEmptyFile {
    [OutputType([void])]

    $fileName = [Microsoft.VisualBasic.Interaction]::InputBox("Digite nome do arquivo (com a extensão):", "", "")

    if (-not $fileName) {
        $saida = "Nome do arquivo não fornecido."

        SendLog -Message $saida
        return
    }

    if (Test-Path ".\$caminhoArquivos\$fileName") {
        $saida = "Arquivo '$fileName' já existe."

        SendLog -Message $saida

        return
    }

    $saida = "Arquivo '$fileName' criado com sucesso."

    SendLog -Message $saida
    New-Item -Path ".\$caminhoArquivos\$fileName" -ItemType File | Out-Null
}

function CreateLixeiraForm {
    [OutputType([System.Windows.Forms.Form])]

    [System.Windows.Forms.Form] $frm = CreateForm -Title "Lixeira" -Width 500 -Height 420

    [System.Windows.Forms.TableLayoutPanel] $tableLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayout.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayout.ColumnCount = 1

    [System.Windows.Forms.Label] $label_SelectOption = New-Object System.Windows.Forms.Label
    $label_SelectOption.Text = "Selecione a opção desejada:"
    $label_SelectOption.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $label_SelectOption.AutoSize = $true
    $label_SelectOption.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $label_SelectOption.Anchor = [System.Windows.Forms.AnchorStyles]::None

    [System.Windows.Forms.Button] $button_MoveToBin = New-Object System.Windows.Forms.Button
    $button_MoveToBin.Text = "Mover para lixeira"
    $button_MoveToBin.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_MoveToBin.Size = New-Object System.Drawing.Size(300, 35)
    $button_MoveToBin.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_MoveToBin.Add_Click({
            MoveToBin    
        })

    [System.Windows.Forms.Button] $button_RestoreFromBin = New-Object System.Windows.Forms.Button
    $button_RestoreFromBin.Text = "Restaurar arquivo"
    $button_RestoreFromBin.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_RestoreFromBin.Size = New-Object System.Drawing.Size(300, 35)
    $button_RestoreFromBin.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_RestoreFromBin.Add_Click({
            RestoreFromBin
        })

    [System.Windows.Forms.Button] $button_RemoveFromBin = New-Object System.Windows.Forms.Button
    $button_RemoveFromBin.Text = "Remover da lixeira"
    $button_RemoveFromBin.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_RemoveFromBin.Size = New-Object System.Drawing.Size(300, 35)
    $button_RemoveFromBin.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_RemoveFromBin.Add_Click({
            RemoveFromBin
        })

    [System.Windows.Forms.Button] $button_ShowRecycleBin = New-Object System.Windows.Forms.Button
    $button_ShowRecycleBin.Text = "Mostrar conteúdo da lixeira"
    $button_ShowRecycleBin.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_ShowRecycleBin.Size = New-Object System.Drawing.Size(300, 35)
    $button_ShowRecycleBin.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_ShowRecycleBin.Add_Click({
        Start-Process -FilePath "explorer.exe" -ArgumentList "$caminhoLixeira"
        })
    
    [System.Windows.Forms.Button] $button_CreateEmptyFile = New-Object System.Windows.Forms.Button
    $button_CreateEmptyFile.Text = "Criar arquivo vazio"
    $button_CreateEmptyFile.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_CreateEmptyFile.Size = New-Object System.Drawing.Size(300, 35)
    $button_CreateEmptyFile.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_CreateEmptyFile.Add_Click({
            CreateEmptyFile
        })

    [System.Windows.Forms.Button] $button_Exit = New-Object System.Windows.Forms.Button
    $button_Exit.Text = "Sair"
    $button_Exit.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_Exit.Size = New-Object System.Drawing.Size(300, 35)
    $button_Exit.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_Exit.Add_Click({
            $frm.Close()
        }.GetNewClosure())

    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout.Controls.Add($label_SelectOption)
    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout.Controls.Add($button_MoveToBin)
    $tableLayout.Controls.Add($button_RestoreFromBin)
    $tableLayout.Controls.Add($button_RemoveFromBin)
    $tableLayout.Controls.Add($button_ShowRecycleBin)
    $tableLayout.Controls.Add($button_CreateEmptyFile)
    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout.Controls.Add($button_Exit)
    $tableLayout.Controls.Add((New-Object System.Windows.Forms.Label))

    $frm.Controls.Add($tableLayout)
    
    return $frm
}

function Main {
    [OutputType([void])]

    [System.Windows.Forms.Form] $frm_Main = CreateForm -Title "Projeto Sistemas Operacionais 2" -Width 500 -Height 355

    [System.Windows.Forms.TableLayoutPanel] $tableLayout_Container = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayout_Container.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayout_Container.ColumnCount = 1

    [System.Windows.Forms.Label] $label_SelectOption = New-Object System.Windows.Forms.Label
    $label_SelectOption.Text = "Selecione a opção desejada:"
    $label_SelectOption.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $label_SelectOption.AutoSize = $true
    $label_SelectOption.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $label_SelectOption.Anchor = [System.Windows.Forms.AnchorStyles]::None

    [System.Windows.Forms.Button] $button_KillProcess = New-Object System.Windows.Forms.Button
    $button_KillProcess.Text = "Finalizar processos"
    $button_KillProcess.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_KillProcess.Size = New-Object System.Drawing.Size(300, 35)
    $button_KillProcess.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_KillProcess.Add_Click({
        ([System.Windows.Forms.Form] (CreateKillProcessForm)).ShowDialog()
        })

    [System.Windows.Forms.Button] $button_LogsList = New-Object System.Windows.Forms.Button
    $button_LogsList.Text = "Listar logs"
    $button_LogsList.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_LogsList.Size = New-Object System.Drawing.Size(300, 35)
    $button_LogsList.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_LogsList.Add_Click({
        Start-Process -FilePath "notepad.exe" -ArgumentList "$caminhoArquivoLog"
    })

    [System.Windows.Forms.Button] $button_StartNotepad = New-Object System.Windows.Forms.Button
    $button_StartNotepad.Text = "Iniciar Bloco de Notas"
    $button_StartNotepad.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_StartNotepad.Size = New-Object System.Drawing.Size(300, 35)
    $button_StartNotepad.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_StartNotepad.Add_Click({
            Start-Process -FilePath "notepad.exe"

            $saida = "Processo 'Notepad' foi iniciado."
            SendLog -Message $saida
        })

    [System.Windows.Forms.Button] $button_Lixeira = New-Object System.Windows.Forms.Button
    $button_Lixeira.Text = "Lixeira"
    $button_Lixeira.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_Lixeira.Size = New-Object System.Drawing.Size(300, $label_SelectOption.PreferredHeight)
    $button_Lixeira.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_Lixeira.Add_Click({
        ([System.Windows.Forms.Form] (CreateLixeiraForm)).ShowDialog()
        })

    [System.Windows.Forms.Button] $button_Exit = New-Object System.Windows.Forms.Button
    $button_Exit.Text = "Sair"
    $button_Exit.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 15)
    $button_Exit.Size = New-Object System.Drawing.Size(300, $label_SelectOption.PreferredHeight)
    $button_Exit.Anchor = [System.Windows.Forms.AnchorStyles]::None
    $button_Exit.Add_Click({
            $frm_Main.Close()
        }.GetNewClosure())

    $tableLayout_Container.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout_Container.Controls.Add($label_SelectOption)
    $tableLayout_Container.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout_Container.Controls.Add($button_KillProcess)
    $tableLayout_Container.Controls.Add($button_LogsList)
    $tableLayout_Container.Controls.Add($button_StartNotepad)
    $tableLayout_Container.Controls.Add($button_Lixeira)
    $tableLayout_Container.Controls.Add((New-Object System.Windows.Forms.Label))
    $tableLayout_Container.Controls.Add($button_Exit)
    $tableLayout_Container.Controls.Add((New-Object System.Windows.Forms.Label))

    $frm_Main.Controls.Add($tableLayout_Container)

    $frm_Main.ShowDialog()
}

Main