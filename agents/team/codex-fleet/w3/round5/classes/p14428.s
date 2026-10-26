# n=5 model=out iset=I1 prefix14_class=14428
mov S2, P2
mov S1, P3
cmp S2, P0
cmovl P2, P0
cmovge S2, P0
cmp P1, P3
cmovg P3, P1
cmovle S1, P1
mov P1, S1
cmp P1, S2
cmovl S1, P3
cmovg P1, S2
cmovg S2, S1
cmp P2, P3
