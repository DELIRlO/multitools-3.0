Tools Shell - Sistema de Diagnóstico para Windows
Uma ferramenta gráfica de diagnóstico e monitoramento para Windows desenvolvida em PowerShell com interface WinForms.

📋 Funcionalidades
🔧 Rede e Conectividade
Exibe IP local e público

Lista adaptadores de rede ativos

Mostra velocidade de conexão

💻 Sistema e Hardware
Informações do computador e usuário

Detalhes do sistema operacional

Especificações do processador

Monitoramento de memória RAM

Espaço em disco disponível

👥 Usuários e Segurança
Lista todos os usuários locais

Status de ativação/desativação

Data do último logon

📊 Monitoramento e Logs
Visualização de eventos do sistema

Logs recentes de aplicativos

Monitoramento de desempenho

⚡ Otimização e Performance (em desenvolvimento)
Limpeza de arquivos temporários

Otimização de memória

Gerenciamento de processos

🔍 Assistente de Diagnóstico (em desenvolvimento)
Diagnóstico automático de problemas

Recomendações de otimização

Relatórios detalhados

🚀 Como Executar
Método 1 - Execução Direta
powershell
# Execute no PowerShell como Administrador
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
.\Tools-Shell.ps1
Método 2 - Via Arquivo BAT
batch
@echo off
powershell -ExecutionPolicy Bypass -File "Tools-Shell.ps1"
pause
Método 3 - Linha de Comando
powershell
powershell -ExecutionPolicy Bypass -Command "& { . .\Tools-Shell.ps1; }"
📦 Requisitos do Sistema
Windows 10 ou Windows 11

PowerShell 5.1 ou superior

Privilégios de Administrador (recomendado)

.NET Framework 4.5 ou superior

🛠️ Desenvolvimento
Estrutura do Projeto
text
Tools-Shell/
├── Tools-Shell.ps1          # Script principal
├── README.md               # Documentação
├── LICENSE                 # Licença MIT
└── Examples/               # Exemplos de uso
Personalização
O código é modular e fácil de personalizar. Adicione novas funcionalidades editando as funções:

powershell
function Get-NetworkInfo {
    # Sua implementação aqui
    Write-OutputBox "Nova funcionalidade de rede"
}
🔒 Segurança
Open Source: Código totalmente transparente

Sem coleta de dados: Não coleta informações pessoais

Execução local: Todos os processos são executados localmente

Permissões mínimas: Solicita apenas permissões necessárias

📊 Screenshots
Interface moderna com tema escuro e layout intuitivo

https://via.placeholder.com/800x600/2D2D30/FFFFFF?text=Tools+Shell+Interface

🤝 Contribuição
Contribuições são bem-vindas! Siga estes passos:

Faça um Fork do projeto

Crie uma Branch para sua feature (git checkout -b feature/AmazingFeature)

Commit suas mudanças (git commit -m 'Add AmazingFeature')

Push para a Branch (git push origin feature/AmazingFeature)

Abra um Pull Request

📝 Licença
Distribuído sob licença MIT. Veja LICENSE para mais informações.

👨‍💻 Desenvolvedor
ysneshy - GitHub

🆘 Suporte
Encontrou um problema?

Verifique se está executando como Administrador

Confirme que o PowerShell está atualizado

Execute Get-ExecutionPolicy e certifique-se de estar RemoteSigned

powershell
# Para troubleshooting
Get-ExecutionPolicy -List
