# n=5 model=out iset=I1 prefix14_class=3357
mov S0, P3
mov S1, P0
cmp P2, S0
cmovle S0, P2
cmovg P3, P2
mov S2, S0
cmp P1, P0
cmovle S1, P1
cmovge P0, P1
cmp S2, S1
cmovge S0, S1
cmovg S1, S2
cmp P3, P0
mov P2, S1
