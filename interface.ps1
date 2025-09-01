Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Formulário Principal
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "Tools Shell - by ysneshy"
$mainForm.Size = New-Object System.Drawing.Size(800, 600)
$mainForm.StartPosition = "CenterScreen"
$mainForm.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$mainForm.ForeColor = [System.Drawing.Color]::White
$mainForm.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Categorias simplificadas
$categories = @(
    "Rede e Conectividade",
    "Sistema e Hardware", 
    "Usuários e Segurança",
    "Monitoramento e Logs",
    "Otimização e Performance",
    "Assistente de Diagnóstico",
    "Ajuda e Documentação",
    "Sair"
)

# Criar botões com posicionamento simplificado
$yPosition = 20
foreach ($category in $categories) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $category
    $btn.Size = New-Object System.Drawing.Size(200, 40)
    $btn.Location = New-Object System.Drawing.Point(20, $yPosition)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = "Flat"
    $btn.Add_Click({ Button-Click $this.Text })
    $mainForm.Controls.Add($btn)
    $yPosition += 50
}

# Área de Texto para Output
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(250, 20)
$outputBox.Size = New-Object System.Drawing.Size(520, 520)
$outputBox.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$outputBox.ForeColor = [System.Drawing.Color]::LightGreen
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$outputBox.ReadOnly = $true
$mainForm.Controls.Add($outputBox)

# Label de Status
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(20, 450)
$statusLabel.Size = New-Object System.Drawing.Size(200, 50)
$statusLabel.Text = "Pronto..."
$mainForm.Controls.Add($statusLabel)

# Função para atualizar status
function Update-Status {
    param($text)
    $statusLabel.Text = $text
    $mainForm.Refresh()
}

# Função para mostrar output
function Write-OutputBox {
    param($text)
    $outputBox.AppendText("$text`r`n")
    $outputBox.ScrollToCaret()
}

# Função chamada quando botão é clicado
function Button-Click {
    param($buttonText)
    
    $outputBox.Clear()
    Update-Status "Executando: $buttonText"
    
    switch ($buttonText) {
        "Rede e Conectividade" { Get-NetworkInfo }
        "Sistema e Hardware" { Get-SystemInfo }
        "Usuários e Segurança" { Get-UserInfo }
        "Monitoramento e Logs" { Get-Logs }
        "Otimização e Performance" { Write-OutputBox "Otimização - Em desenvolvimento" }
        "Assistente de Diagnóstico" { Write-OutputBox "Diagnóstico - Em desenvolvimento" }
        "Ajuda e Documentação" { Show-Help }
        "Sair" { $mainForm.Close() }
    }
    
    Update-Status "Pronto..."
}

# Funções para cada módulo
function Get-NetworkInfo {
    Write-OutputBox "=== REDE E CONECTIVIDADE ==="
    
    # IP Local
    $ipLocal = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
        $_.IPAddress -notlike '169.*' -and $_.IPAddress -ne '127.0.0.1'
    } | Select-Object -First 1 -ExpandProperty IPAddress)
    Write-OutputBox "IP Local: $ipLocal"
    
    # IP Público
    try {
        $publicIP = (Invoke-RestMethod -Uri "https://api.ipify.org").Trim()
        Write-OutputBox "IP Publico: $publicIP"
    } catch {
        Write-OutputBox "IP Publico: Não disponível"
    }
    
    # Adaptadores de Rede
    Write-OutputBox "`n=== ADAPTADORES DE REDE ==="
    $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object Name, InterfaceDescription, LinkSpeed
    foreach ($adapter in $adapters) {
        Write-OutputBox "$($adapter.Name): $($adapter.LinkSpeed)"
    }
}

function Get-SystemInfo {
    Write-OutputBox "=== INFORMACOES DO SISTEMA ==="
    Write-OutputBox "Computador: $env:COMPUTERNAME"
    Write-OutputBox "Usuario: $env:USERNAME"
    Write-OutputBox "SO: $((Get-CimInstance Win32_OperatingSystem).Caption)"
    Write-OutputBox "Processador: $((Get-CimInstance Win32_Processor).Name)"
    
    $memGB = [math]::Round(((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB), 2)
    Write-OutputBox "Memoria Total: $memGB GB"
    
    $ramFreeMB = [math]::Round(((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB), 2)
    Write-OutputBox "RAM Livre: $ramFreeMB MB"
    
    $disk = Get-PSDrive C -ErrorAction SilentlyContinue
    if ($disk) {
        $freeGB = [math]::Round(($disk.Free / 1GB), 2)
        $totalGB = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)
        Write-OutputBox "Disco C:: $freeGB GB livres / $totalGB GB total"
    }
}

function Get-UserInfo {
    Write-OutputBox "=== USUARIOS LOCAIS ==="
    $users = Get-LocalUser | Select-Object Name, Enabled, @{Name="LastLogon"; Expression={if($_.LastLogon) {$_.LastLogon.ToString("dd/MM/yyyy")} else {"Nunca"}}}
    foreach ($user in $users) {
        $status = if ($user.Enabled) {"Ativo"} else {"Desativado"}
        Write-OutputBox "$($user.Name) - $status - Ultimo logon: $($user.LastLogon)"
    }
}

function Get-Logs {
    Write-OutputBox "=== ULTIMOS EVENTOS DO SISTEMA ==="
    try {
        $events = Get-EventLog -LogName System -Newest 5 -ErrorAction Stop | Select-Object TimeGenerated, EntryType, Source
        foreach ($event in $events) {
            Write-OutputBox "$($event.TimeGenerated.ToString('dd/MM HH:mm')) - $($event.EntryType) - $($event.Source)"
        }
    } catch {
        Write-OutputBox "Não foi possível acessar os logs do sistema"
    }
}

function Show-Help {
    Write-OutputBox "=== AJUDA ==="
    Write-OutputBox "Ferramenta de diagnóstico do sistema"
    Write-OutputBox "Desenvolvido por: ysneshy"
    Write-OutputBox "Data: $(Get-Date -Format 'dd/MM/yyyy')"
    Write-OutputBox "`nSelecione uma categoria para ver informações do sistema"
}

# Iniciar a interface
Write-OutputBox "=== TOOLS SHELL - by ysneshy ==="
Write-OutputBox "Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
Write-OutputBox "=================================`n"
Write-OutputBox "Selecione uma opção no menu à esquerda"

$mainForm.ShowDialog()