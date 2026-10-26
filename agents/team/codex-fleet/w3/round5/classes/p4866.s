# n=5 model=out iset=I1 prefix14_class=4866
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
mov S0, P0
cmovle S2, P3
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
cmovg P1, P0
cmp P0, S2
cmovl P0, S2
cmovl S2, P1
cmp P2, S0
cmovg S2, S0
