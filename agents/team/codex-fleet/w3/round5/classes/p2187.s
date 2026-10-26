# n=5 model=out iset=I1 prefix14_class=2187
cmp P1, P3
mov S2, P1
cmovl S2, P3
mov S0, P0
cmovg P1, P3
cmp S0, P2
cmovge P0, P2
cmovge P2, S0
mov S0, P2
mov S1, P0
cmp P2, S2
cmovle P2, S2
cmovl S2, S0
mov P2, S2
