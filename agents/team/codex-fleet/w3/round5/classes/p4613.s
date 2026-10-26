# n=5 model=out iset=I1 prefix14_class=4613
cmp P2, P1
cmovle S2, P1
cmovge S2, P2
cmovl P1, P2
mov P2, S2
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovl P3, S1
cmp P3, S2
cmovge S2, P3
cmovg P3, P2
mov S2, P1
cmovl P2, P3
