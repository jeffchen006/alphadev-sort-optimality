# n=5 model=out iset=I1 prefix14_class=1599
mov S0, P1
mov S2, P2
cmp P2, P0
cmovg P2, P0
cmovg P0, S2
mov S2, P2
cmp P3, S0
cmovl S0, P3
cmovge P1, P3
cmp S2, S0
cmovle P2, S0
mov P3, P2
cmovl S0, S2
cmp P1, P0
