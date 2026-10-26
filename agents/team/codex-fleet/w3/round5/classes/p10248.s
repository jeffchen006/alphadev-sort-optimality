# n=5 model=out iset=I1 prefix14_class=10248
cmp P0, P3
cmovle S0, P0
cmovl P0, P3
cmovge S0, P3
mov S2, P2
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmp S2, P0
cmovg P3, S2
mov P2, P1
cmovge S2, P0
mov S1, S2
cmovg P0, P3
