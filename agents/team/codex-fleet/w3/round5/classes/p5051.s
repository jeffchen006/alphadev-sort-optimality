# n=5 model=out iset=I1 prefix14_class=5051
mov S2, P3
cmp P2, S2
cmovge P3, P2
mov S0, P0
cmovg P2, S2
cmp P1, P0
cmovle P0, P1
cmovg S0, P1
cmp P0, P2
mov S2, P2
cmovle P2, P0
cmovg S2, P0
cmp S0, P3
cmovg S1, S0
