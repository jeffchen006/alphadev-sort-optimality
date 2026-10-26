# n=5 model=out iset=I1 prefix14_class=9056
mov S2, P3
mov S1, P1
cmp P0, S1
cmovle S1, P0
cmovl P0, P1
cmp P2, P3
cmovge S2, P2
cmovl P3, P2
cmp S2, P0
cmovl P2, S2
cmovl S2, P0
cmovl P0, P2
mov P1, P3
mov S2, P0
