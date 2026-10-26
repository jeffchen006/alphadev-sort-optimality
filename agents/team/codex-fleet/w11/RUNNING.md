# Independent C2 state

Recorded at 2026-10-26 08:07 UTC. C2 is incomplete. No sort5 k<=31 PASS exists.

The latest supervisor decision assigns both main C2 variants to d2. New target
runs in this folder must cross-check completed d2 cases. No broad prefix sweep
was restarted in this turn. The prior two tool sessions are unavailable. Four
interrupted RUNNING nodes were returned to PENDING. This changed no decision.
See independent/session_recovery.json.

The d2 c2/results folder has 12 V2 records. Each is UNKNOWN after a 3600-second
limit. None has a verified UNSAT decision. The requested
position-case cross-check has decided 0 / remaining 3280 / unknown 3280.
The V1 scope has 1351 cases. The V2 scope has 1929 cases. The empty available
queue does not close either scope.

Two short observation runs are logged in logs/peer_watch.log and
logs/peer_watch_v2.log. The second runner uses the corrected total-scope
counter in independent/crosscheck_status.json. The first log counts only the
empty available queue. Use the second log for the required campaign count.

To resume the completed-case observer with at most four CPU workers:

    nice -n 10 python3 -u src/watch_peer.py --workers 4

The observer never imports a peer encoder. It distinguishes V1 and V2. It maps
peer block cubes through their saved semantic sizes. It runs an independent
105-prefix partition inside each completed peer case. Each independent UNSAT
needs a fresh DRAT certificate and a successful drat-trim check. Every parent
that closes through cubes also needs an independently checked cover proof.
An independent strict SAT result writes DISAGREEMENT.json and stops the runner.
A two-hour progress timer appends decided / remaining / unknown to RESULTS.md.

The completed certificate audit covers all 351 saved UNSAT certificates.
independent/CERTIFICATE_MANIFEST.json records hashes and replay evidence.
The 314 revision-2 target certificates close 310 first-data prefix roots out
of 1575. They do not close a comparison count or a position case. The exact
closed scope is independent/CLOSED_SCOPE.json. Do not add overlapping revisions.

The independent encoder is src/independent_c2.py. Its SHA-256 is
2d5c0df3384bcda7aa47df63622c96be9b02e00e5415c1b79e858afe340e8004.
The review packet is independent/REVIEW.md. Judge acceptance remains pending.

SendMessage is unavailable. The filesystem rule excludes shared inbox writes.
MESSAGE_TO_D2.md contains the update for supervisor relay.
