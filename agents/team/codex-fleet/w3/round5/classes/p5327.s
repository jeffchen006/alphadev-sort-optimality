# n=5 model=out iset=I1 prefix14_class=5327
mov S1, P2
cmp P3, S1
mov S2, P1
cmovg P2, P3
cmovle S1, P3
cmp P1, P0
cmovl P1, P0
cmovge S2, P0
cmp S2, S1
mov S0, S1
cmovl S1, S2
cmovge S0, S2
mov S2, P1
mov S1, S0
