# n=5 model=out iset=I1 prefix14_class=2912
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovl S0, P1
mov S2, P2
mov S1, P0
cmp P3, S2
cmovge S2, P3
cmovge P3, P2
cmp S2, S1
cmovle P0, S2
cmovl S2, S1
cmp S0, P3
cmovg S1, P0
