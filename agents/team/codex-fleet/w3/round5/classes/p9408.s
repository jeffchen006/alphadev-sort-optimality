# n=5 model=out iset=I1 prefix14_class=9408
mov S0, P0
cmp P1, S0
cmovg S0, P1
mov S2, P3
cmovge P1, P0
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmp P1, S2
cmovg P0, P1
cmovg P1, S2
cmovg S2, P0
mov S1, S2
cmp S0, P2
