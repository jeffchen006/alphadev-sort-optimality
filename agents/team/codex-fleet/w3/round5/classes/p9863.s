# n=5 model=out iset=I1 prefix14_class=9863
cmp P2, P1
mov S1, P1
cmovg P1, P2
cmovl S1, P2
cmp P3, P0
cmovge S2, P0
cmovg P0, P3
mov S0, P1
cmovg P3, S2
cmp P0, P1
cmovl P1, P0
cmovle P0, S0
cmp P3, S1
cmovg S0, P3
