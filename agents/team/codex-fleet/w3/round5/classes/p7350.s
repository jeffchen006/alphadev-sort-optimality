# n=5 model=out iset=I1 prefix14_class=7350
cmp P3, P1
cmovg S1, P1
cmovg P1, P3
cmovle S1, P3
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
mov P3, P2
cmovl P0, S0
cmp P2, S1
cmovl P3, S1
mov S2, P0
cmovle S1, P2
cmp P0, P1
