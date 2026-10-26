# n=5 model=out iset=I1 prefix14_class=7951
cmp P3, P1
mov S0, P1
cmovg S0, P3
mov S1, P2
cmovg P3, P1
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
mov P2, S0
cmp P3, S1
cmovg P1, S1
cmovge S1, P3
cmovg P3, P1
cmp P2, P0
