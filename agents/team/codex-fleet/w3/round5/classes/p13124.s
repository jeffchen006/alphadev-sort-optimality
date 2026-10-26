# n=5 model=out iset=I1 prefix14_class=13124
cmp P0, P1
mov S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P3, P2
mov P1, P3
cmovl P1, P2
cmovg P3, P2
mov S0, P1
cmp P3, S1
cmovl P2, P3
cmovle P3, S1
mov S2, P3
cmovl S1, P2
