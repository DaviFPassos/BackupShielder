# BackupShield: Automated Log Rotator & System Archiver

O **BackupShield** é uma ferramenta de automação de infraestrutura e administração de sistemas (SysAdmin) desenvolvida para gerenciar o armazenamento de servidores de produção. O projeto utiliza o poder bruto do **Shell Script (Bash)** em mais de 90% da sua base de código para interagir diretamente com o sistema operacional, compactar logs voláteis e auditar a integridade de arquivos, contando com o **Python** exclusivamente para a formatação estruturada de relatórios executivos.

---

## 🏗️ Fluxo de Execução da Infraestrutura

O pipeline executa rotinas críticas de manutenção diretamente no Kernel do Linux através de um fluxo linear e seguro:

```text
[ SISTEMA OPERACIONAL ]
          │
 (Varredura de Armazenamento)
          ▼
┌────────────────────────────────────────────────────────┐
│ 1. CORE EM SHELL SCRIPT (Bash ~95%)                    │
│    - Analisa o uso de disco ativo (`df -h`).           │
│    - Localiza artefatos voláteis na aplicação.         │
│    - Compacta logs em tempo de execução (`tar -czf`).  │
│    - Gera assinaturas de segurança digitais (`md5sum`).│
└────────────────────────┬───────────────────────────────┘
                         │
           (Transfere métricas via sys.argv)
                         ▼
┌────────────────────────────────────────────────────────┐
│ 2. REPORTE EM PYTHON (Engine ~5%)                      │
│    - Captura os dados operacionais do Bash.            │
│    - Envelopa as métricas em formato padronizado JSON. │
│    - Exibe o relatório de auditoria no terminal.       │
└────────────────────────────────────────────────────────┘
```
---
# 📂 Estrutura do Repositório
```
BackupShield/
│
├── backup_vault/            # Cofre seguro contendo os tarballs (.tar.gz) gerados (Ignorado pelo Git)
├── logs/                    # Histórico de auditoria e logs do sistema (Ignorado pelo Git)
├── source_apps/             # Diretório que simula a geração de logs pelas aplicações
│   └── *.txt                # Arquivos voláteis de texto processados (Ignorados pelo Git)
│
├── .gitignore               # Definição de políticas de segurança e governança de dados
├── backup_shield.sh         # Script principal (Orquestrador e Executor Bash)
├── helper_formatter.py      # Micro-auxiliar de apresentação em Python
└── README.md                # Documentação técnica do projeto
```
---

# ⚙️ Configuração e Instalação (Ambiente Unix / WSL2)

Pré-requisitos:

* O script utiliza utilitários nativos de distribuições Linux (como Ubuntu e Debian). Certifique-se de que possui permissões de administrador para rodar comandos de leitura de disco e manipulação de arquivos.

1. Preparação do Ambiente
Abra o terminal do seu Ubuntu no WSL2 e navegue até a pasta do projeto para garantir a permissão de execução do orquestrador:

```
Bash
cd ~path_to_project
chmod +x file.sh
```
2. Simulação de Carga (Gerar logs falsos)
Caso queira testar a ferramenta com novos arquivos temporários antes de rodar o motor principal, execute o gerador de estresse abaixo no terminal:

```
Bash
for i in {1..5}; do echo "Log de sistema pesado número $i" > source_apps/app_log_0$i.txt; done
```

3. Execução do Script
Rode o utilitário principal:

```
Bash
./file.sh
```

---
```
# 📊 Relatório de Auditoria e Logs
Ao finalizar a compressão e purga dos arquivos da pasta de origem, o script retorna um relatório executivo estruturado em formato JSON no terminal:

```
JSON
📋 EXECUTION METRICS REPORT (JSON OUTPUT):
{
    "pipeline_status": "COMPLETED_AND_SECURED",
    "execution_time": "2026-05-20 02:15:00",
    "metrics": {
        "host_disk_usage_percent": "42%",
        "integrity_verified": true,
        "payload_checksum": "b37492cda112349e1a9c402a7b819f01"
    },
    "infrastructure_action": "Source logs purged. Tarball moved to secure vault."
}
Além disso, o histórico completo fica salvo no arquivo de persistência local logs/backup_history.log, registrando datas, status de sucesso ou falhas críticas do Kernel para auditorias posteriores do SysAdmin.
```

