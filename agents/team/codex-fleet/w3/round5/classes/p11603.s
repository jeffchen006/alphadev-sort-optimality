# n=5 model=out iset=I1 prefix14_class=11603
cmp P3, P1
mov S2, P3
cmovg P3, P1
cmovg P1, S2
cmp P2, P0
mov S0, P0
cmovg S0, P2
cmovle P0, P2
cmp P1, S0
cmovge S1, P1
cmovge P1, S0
cmovg S0, S1
cmp P3, P0
mov S0, P1
