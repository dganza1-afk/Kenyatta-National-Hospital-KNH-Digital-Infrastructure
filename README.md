# Coding-lab_GroupXX — Hospital System Automation

Shell-scripted setup, analysis, and archiving layer around `hospital_system.py`,
KNH's patient-monitoring engine. Built for a coursework assignment; **no real
patient data is ever committed to this repository** (see `.gitignore`).

## Project Structure

```
Coding-lab_GroupXX/
├── hospital_system.py      # The Engine — core system logic
├── hospital_admin.sh       # M1–M3 — environment setup & permissions
├── hospital_analysis.sh    # M5–M6 — reporting & analytics
├── hospital_archive.sh     # M4 — log rotation / archiving
├── .gitignore              # Excludes logs and generated reports
└── README.md
```

## Group Roles

| Member | Role | Script | Function(s) |
|---|---|---|---|
| Member 1 | The Architect | `hospital_admin.sh` | `initialize_system()` |
| Member 2 | The Security Lead | `hospital_admin.sh` | `secure_data()` |
| Member 3 | The Orchestrator | `hospital_admin.sh` | `main()` execution logic |
| Member 4 | The Archivist | `hospital_archive.sh` | `rotate_logs()` |
| Member 5 | Clinical Analyst | `hospital_analysis.sh` | `process_vitals()` |
| Member 6 | Facility Auditor | `hospital_analysis.sh` | `water_audit()` |

## Usage

Run once per day (or per shift) in this order:

```bash
chmod +x hospital_admin.sh hospital_analysis.sh hospital_archive.sh

./hospital_admin.sh      # M1-M3: create + lock down directories
# ... hospital_system.py writes to active_logs/ during the day ...
./hospital_analysis.sh   # M5-M6: pull critical alerts + water audit
./hospital_archive.sh    # M4: rotate active_logs -> archived_logs
```

## Expected Log Format

`hospital_system.py` is assumed to write comma-separated logs into
`active_logs/`:

- `heart_rate.log`  → `Timestamp,Device_ID,Value,Status`
- `temperature.log` → `Timestamp,Device_ID,Value,Status`
- `water_usage.log` → `Timestamp,Reserve_ID,Usage_Liters`

`Status` is `NORMAL` or `CRITICAL`. `Reserve_ID` includes `ICU_WATER_RESERVE`
among possibly other reserves. If the engine's real column order differs,
update the `awk -F','` field numbers in `hospital_analysis.sh` accordingly.

## Outputs

- `reports/critical_alerts.txt` — every CRITICAL heart-rate/temperature
  reading, as `Timestamp,Device_ID,Value`.
- Console — a formatted water-usage summary (readings, total, average) for
  `ICU_WATER_RESERVE`.
- `archived_logs/<name>_<YYYYMMDD_HHMM>.log` — one fresh timestamped file
  per rotation; `active_logs/` is left with empty files of the same names
  so the Python engine can keep recording without interruption.

## Data Safety

Per KNH policy, `active_logs/`, `archived_logs/`, `reports/`, and the
engine's PID file are all git-ignored. Never `git add -f` anything inside
those paths.

## Git Workflow

1. Each member works on their own branch, e.g. `git checkout -b logic-archiving`.
2. Branches are merged into `main` once reviewed.
3. Each member should have at least 3 commits reflecting their own
   contribution (e.g. initial function, refinement, bug fix/comments).
