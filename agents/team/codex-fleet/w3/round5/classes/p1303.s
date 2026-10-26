# n=5 model=out iset=I1 prefix14_class=1303
cmp P0, P3
mov S1, P1
cmovge S2, P3
cmovl S2, P0
cmovl P0, P3
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
mov P3, S1
mov S0, P2
cmp S1, P0
cmovle P3, P0
cmovge S1, P0
mov P1, S1
