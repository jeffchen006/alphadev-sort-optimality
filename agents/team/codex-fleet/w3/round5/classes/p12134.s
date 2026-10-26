# n=5 model=out iset=I1 prefix14_class=12134
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P1, P2
cmovge S1, P1
mov S0, P3
cmovge P1, P2
cmovge P2, S1
cmp P1, P3
cmovg S0, P1
cmovge P1, P3
mov P1, S0
mov P3, P2
