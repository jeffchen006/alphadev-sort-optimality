# n=5 model=out iset=I1 prefix14_class=2044
mov S1, P0
cmp P3, P0
cmovl S1, P3
cmovge P0, P3
cmp P1, P2
cmovg S2, P1
cmovg P1, P2
cmovg P2, S2
mov P3, P2
cmp P2, P0
cmovg P2, P0
mov S0, S1
cmovle P3, P0
cmp S0, P1
