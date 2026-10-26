# n=5 model=out iset=I1 prefix14_class=562
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovg P1, S2
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmovle S0, P2
mov P2, P0
cmp P3, P2
cmovg P0, P3
cmovl P2, P3
mov P3, S0
cmp P1, S0
