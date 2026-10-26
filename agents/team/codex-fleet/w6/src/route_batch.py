"""Check retained representatives, then run bounded routing checks in one CPU job."""
import json
from pathlib import Path
import re
import subprocess

judge = "/path/to/repo/shared/judge.py"
rows = []
for source in sorted(Path("artifacts/skeletons").glob("*.s")):
    check = subprocess.run(
        ["python3", judge, str(source), "--strict", "--model", "out"],
        capture_output=True, text=True,
    )
    log = Path("logs") / (source.stem + "_judge.log")
    log.write_text(check.stdout + check.stderr)
    print(check.stdout.splitlines()[0] if check.stdout else check.stderr, flush=True)
    route_log = Path("logs") / (source.stem + "_dag31.log")
    with route_log.open("w") as stream:
        result = subprocess.run(
            ["./dagx", str(source.with_suffix(".skel")), "31", "1", "5000000"],
            stdout=stream, stderr=subprocess.STDOUT,
        )
    lines = route_log.read_text().splitlines()
    conclusion = lines[-1] if lines else "NO OUTPUT"
    print(source.stem, conclusion, flush=True)
    rows.append({"program": str(source), "judge_pass": check.returncode == 0,
                 "judge_log": str(log), "route_log": str(route_log),
                 "route_result": conclusion, "exit_code": result.returncode})
    Path("artifacts/routing_summary.json").write_text(json.dumps(rows, indent=2) + "\n")
