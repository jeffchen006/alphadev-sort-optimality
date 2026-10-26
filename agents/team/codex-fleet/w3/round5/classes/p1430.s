# n=5 model=out iset=I1 prefix14_class=1430
mov S0, P1
mov S1, P3
cmp P1, P0
cmovge P1, P0
cmovg P0, S0
cmp P2, S1
mov S2, P1
cmovge P3, P2
cmovge P2, S1
mov S1, P3
cmp P3, P0
cmovl S1, P0
cmovge P3, P0
cmovle P0, P3
