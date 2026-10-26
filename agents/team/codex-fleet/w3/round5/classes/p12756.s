# n=5 model=out iset=I1 prefix14_class=12756
cmp P3, P0
cmovg S0, P0
cmovg P0, P3
cmovg P3, S0
mov S2, P2
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
cmovge P1, P3
mov P1, S2
cmp S2, P0
