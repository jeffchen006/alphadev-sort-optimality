# n=5 model=out iset=I1 prefix14_class=785
mov S1, P0
mov S2, P3
cmp S2, P2
cmovle S2, P2
cmovle P2, P3
cmp P0, P1
cmovl S1, P1
cmovg P0, P1
cmp S1, S2
mov S0, S2
mov P1, P2
cmovl S0, S1
cmovge S2, S1
cmp P2, P0
