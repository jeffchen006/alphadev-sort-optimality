"""Strictly judge the retained representatives and small named controls."""
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import subprocess

judge = "/path/to/repo/shared/judge.py"
paths = set(Path("verified").glob("*.s"))
paths.update(Path("artifacts/skeletons").glob("*.s"))
paths.update(Path("seeds").glob("*.s"))
paths.update(Path("artifacts").glob("sort5*.s"))
paths.update(Path("candidates").glob("*_k32.s"))
paths.update(Path("candidates").glob("c8?_len*.s"))


def check(path):
    model = "mem" if "_mem.s" in path.name else "out"
    result = subprocess.run(["python3", judge, str(path), "--strict", "--model", model],
                            capture_output=True, text=True)
    row = {"path": str(path), "model": model, "pass": result.returncode == 0,
           "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
           "output": result.stdout + result.stderr}
    print(row["output"], end="", flush=True)
    return row


with ThreadPoolExecutor(max_workers=2) as pool:
    rows = list(pool.map(check, sorted(paths)))
Path("artifacts/all_judge_results.json").write_text(json.dumps(rows, indent=2) + "\n")
print(f"SUMMARY files={len(rows)} PASS={sum(r['pass'] for r in rows)}", flush=True)
