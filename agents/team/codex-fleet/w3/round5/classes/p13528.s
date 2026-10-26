# n=5 model=out iset=I1 prefix14_class=13528
mov S2, P0
cmp S2, P1
cmovge S2, P1
cmovl P0, P1
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
mov P1, S2
cmovl P2, S1
cmp P2, P1
cmovg P1, P2
cmovle S2, P2
mov S2, P3
cmp P0, P3
