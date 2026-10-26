# n=5 model=out iset=I1 prefix14_class=4731
cmp P3, P1
mov S2, P3
mov S1, P0
cmovle P3, P1
cmovg S2, P1
cmp P2, S1
cmovg S1, P2
cmovg P2, P0
mov S0, S2
cmp P2, S0
cmovg S2, P2
cmovge P2, S0
cmp S1, P3
cmovge P2, P3
