"""Route comparison structures that were not in the first twelve."""
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import subprocess

old = {Path(x["program"]).stem for x in json.loads(Path("artifacts/routing_summary.json").read_text())}
sources = [p for p in sorted(Path("artifacts/skeletons").glob("*.skel"))
           if p.stem not in old and p.stem != "c8_15d47dd100cf7fcb"]


def check(source):
    log = Path("logs") / (source.stem + "_new_dag31.log")
    with log.open("w") as stream:
        result = subprocess.run(["./dagx", str(source), "31", "1", "10000000"],
                                stdout=stream, stderr=subprocess.STDOUT)
    line = log.read_text().splitlines()[-1]
    print(source.stem, line, flush=True)
    return {"skeleton": str(source), "log": str(log), "result": line,
            "exit_code": result.returncode}


with ThreadPoolExecutor(max_workers=4) as pool:
    rows = list(pool.map(check, sources))
Path("artifacts/new_routing_summary.json").write_text(json.dumps(rows, indent=2) + "\n")
