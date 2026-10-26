# n=5 model=out iset=I1 prefix14_class=9253
mov S2, P2
cmp P3, P0
mov S1, P3
cmovge S1, P0
cmovl P3, P0
cmp P1, P2
cmovle S2, P1
cmovge P2, P1
cmp S2, S1
cmovl P1, S1
cmovl S1, S2
cmovl S2, P1
cmp P3, P2
cmovl P0, P3
