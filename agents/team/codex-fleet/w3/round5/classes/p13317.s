# n=5 model=out iset=I1 prefix14_class=13317
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmovg P3, S2
mov S0, P1
cmp P1, P0
cmovl P1, P0
mov S1, P2
cmovle P0, S0
cmp P0, S1
cmovg S1, P0
cmovl P2, P0
cmp P3, P1
cmovle P2, P3
