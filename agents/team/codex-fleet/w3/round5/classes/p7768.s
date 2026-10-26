# n=5 model=out iset=I1 prefix14_class=7768
mov S0, P2
cmp S0, P3
cmovge S0, P3
mov S1, P0
cmovle P2, P3
cmp P0, P1
cmovge P0, P1
cmovl S1, P1
cmp P0, S0
cmovge S2, S0
cmovge S0, P0
mov P1, S0
cmovg P0, S2
mov P3, S1
