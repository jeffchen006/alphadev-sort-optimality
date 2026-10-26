# n=5 model=out iset=I1 prefix14_class=2646
cmp P2, P1
mov S0, P3
cmovge S2, P2
cmovg P2, P1
cmovl S2, P1
mov P1, S2
cmp P0, S0
cmovl P3, P0
cmovge S0, P0
cmp S0, S2
cmovle S2, S0
cmovl S0, P1
cmp P3, P2
cmovg P0, P2
