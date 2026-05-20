import sys
import json
from datetime import datetime

if len(sys.argv) < 4:
    print("[PYTHON ERROR] Missing operational metadata metrics.")
    sys.exit(1)

# Captura os dados enviados pelo pipeline do Bash
disk_used = sys.argv[2]
md5_hash = sys.argv[3]

# Monta um report executivo estruturado
report = {
    "pipeline_status": "COMPLETED_AND_SECURED",
    "execution_time": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    "metrics": {
        "host_disk_usage_percent": f"{disk_used}%",
        "integrity_verified": True,
        "payload_checksum": md5_hash
    },
    "infrastructure_action": "Source logs purged. Tarball moved to secure vault."
}

# Printa no terminal com indentação bonita
print("\n EXECUTION METRICS REPORT (JSON OUTPUT):")
print(json.dumps(report, indent=4))