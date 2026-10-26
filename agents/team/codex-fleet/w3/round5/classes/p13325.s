# n=5 model=out iset=I1 prefix14_class=13325
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
mov S0, P3
cmovg P2, S2
cmp P0, P1
mov S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P1, S0
cmovl P3, P1
cmovge S0, P1
cmp P2, P0
mov P3, P0
