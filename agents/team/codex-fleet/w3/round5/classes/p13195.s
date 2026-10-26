# n=5 model=out iset=I1 prefix14_class=13195
mov S0, P0
cmp P3, P0
cmovle S0, P3
cmovg P0, P3
cmp P2, P1
cmovle P3, P2
mov S1, S0
cmovle P2, P1
cmovle P1, P3
cmp S1, P1
cmovg S1, P1
cmovle S0, P1
cmp P2, P0
cmovge P3, P2
