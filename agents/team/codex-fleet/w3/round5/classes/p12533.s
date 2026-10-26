# n=5 model=out iset=I1 prefix14_class=12533
cmp P3, P2
mov S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovge S0, P1
mov S1, P2
cmovg P1, P0
cmovg P0, S0
cmp P1, S1
cmovg S1, P1
cmovg P1, P2
cmp P0, P3
cmovle P1, P0
