# n=5 model=out iset=I1 prefix14_class=5281
mov S0, P3
cmp P0, P1
mov S2, P0
cmovl S2, P1
cmovg P0, P1
cmp P2, P3
cmovg P3, P2
mov S1, P3
cmovl S0, P2
mov P1, P0
cmp P0, S0
cmovge P1, S0
cmovle P0, S0
mov P1, P0
