# n=5 model=out iset=I1 prefix14_class=8660
mov S2, P2
cmp P2, P3
cmovle S2, P3
cmovg P2, P3
cmp P1, P0
cmovl P3, P0
cmovl P0, P1
cmovl P1, P3
cmp S2, P1
mov P3, S2
cmovge S2, P1
cmovl P3, P1
cmp P2, P0
cmovg P1, P2
