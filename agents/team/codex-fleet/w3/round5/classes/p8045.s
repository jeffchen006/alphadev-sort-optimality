# n=5 model=out iset=I1 prefix14_class=8045
cmp P3, P1
cmovge S0, P3
mov S2, P2
cmovg P3, P1
cmovg P1, S0
cmp P0, S2
cmovg S2, P0
cmovge P0, P2
cmp P0, P3
mov P2, P0
cmovg P2, P3
cmovle P0, P3
mov P2, P1
cmovg P3, P0
