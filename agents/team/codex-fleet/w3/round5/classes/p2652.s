# n=5 model=out iset=I1 prefix14_class=2652
mov S2, P0
cmp P0, P3
mov S0, P1
cmovg S2, P3
cmovg P3, P0
cmp P2, P1
mov P0, P3
cmovle P1, P2
cmovg S0, P2
cmp S0, P3
cmovle P0, S0
cmovle S0, P3
cmp S2, P1
cmovge P3, P1
