# n=5 model=out iset=I1 prefix14_class=7094
mov S1, P1
mov S0, P2
cmp P3, S0
cmovg S0, P3
cmovg P3, P2
cmp P1, P0
cmovg P1, P0
mov S2, P3
cmovge P0, S1
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
cmp P0, S0
mov P3, S2
