# n=5 model=out iset=I1 prefix14_class=5038
cmp P0, P2
cmovge S2, P2
cmovl S2, P0
cmovg P2, P0
mov S1, P3
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
mov P3, P1
cmp S2, P3
cmovle P3, S2
cmovg P1, S2
mov P3, P1
mov S0, S1
