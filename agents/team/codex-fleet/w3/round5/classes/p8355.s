# n=5 model=out iset=I1 prefix14_class=8355
cmp P2, P1
mov S0, P1
cmovg S0, P2
cmovle P1, P2
cmp P0, P3
cmovge P2, P0
cmovge P0, P3
mov S2, P1
cmovg P3, P2
cmp P0, S2
mov S1, S0
cmovge S2, P0
cmovg P0, P1
mov P0, S2
