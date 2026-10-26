# n=5 model=out iset=I1 prefix14_class=2185
cmp P2, P3
mov S2, P2
cmovl S2, P3
mov S0, P0
cmovg P2, P3
cmp S0, P1
cmovge P0, P1
cmovge P1, S0
mov S0, P1
mov S1, P2
cmp P1, S2
cmovle P1, S2
cmovl S2, S0
mov P1, S2
