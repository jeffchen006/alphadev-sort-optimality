"""Keep immutable copies, judge each copy, then test local replacements."""
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import subprocess

root = Path.cwd()
judge = "/path/to/repo/shared/judge.py"
Path("verified").mkdir(exist_ok=True)
sources = []
for source in sorted(Path("artifacts/skeletons").glob("*.s")):
    target = Path("verified") / source.name
    if not target.exists():
        target.write_bytes(source.read_bytes())
    sources.append(target)


def check(source):
    log = Path("logs") / ("verified_" + source.stem + "_judge.log")
    result = subprocess.run(["python3", judge, str(source), "--strict", "--model", "out"],
                            text=True, capture_output=True)
    log.write_text(result.stdout + result.stderr)
    row = {"path": str(source), "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
           "pass": result.returncode == 0, "judge_log": str(log)}
    print(result.stdout.splitlines()[0] if result.stdout else result.stderr, flush=True)
    if result.returncode == 0:
        local_log = Path("logs") / ("verified_" + source.stem + "_local3.log")
        with local_log.open("w") as stream:
            local = subprocess.run(["./local", str(source), "candidates/local_" + source.stem + "_31", "3"],
                                   stdout=stream, stderr=subprocess.STDOUT)
        row["local3_exit_code"] = local.returncode
        row["local3_log"] = str(local_log)
        print(source, local_log.read_text().splitlines()[-1], flush=True)
    return row


with ThreadPoolExecutor(max_workers=2) as pool:
    rows = list(pool.map(check, sources))
Path("artifacts/verified_ledger.json").write_text(json.dumps(rows, indent=2) + "\n")
