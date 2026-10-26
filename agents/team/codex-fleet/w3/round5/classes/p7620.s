# n=5 model=out iset=I1 prefix14_class=7620
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
cmovg P3, P1
mov S0, P0
cmp P0, S1
cmovg S0, S1
mov S0, P2
cmovge S1, P0
cmp P3, S0
