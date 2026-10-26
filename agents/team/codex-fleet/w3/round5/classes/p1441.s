# n=5 model=out iset=I1 prefix14_class=1441
mov S0, P3
cmp P1, P0
mov S2, P1
cmovg S2, P0
cmovg P0, P1
cmp P2, S0
cmovg P3, P2
mov P1, P0
cmovg P2, S0
cmp P3, P1
cmovge P0, P3
cmovg P3, P1
cmp P2, S2
cmovg P0, S2
