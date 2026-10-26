# n=5 model=out iset=I1 prefix14_class=4791
mov S2, P2
cmp S2, P0
cmovle S2, P0
cmovl P0, P2
mov S1, P0
cmp P3, P1
mov P2, P3
cmovg P3, P1
cmovg P1, P2
cmp P3, S1
cmovl S1, P3
cmovg P0, P3
cmp S2, P1
cmovge S1, P1
