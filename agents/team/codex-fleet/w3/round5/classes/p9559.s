# n=5 model=out iset=I1 prefix14_class=9559
cmp P1, P0
mov S2, P2
cmovle S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, P3
cmovg P2, P3
cmovg P3, S2
cmp P2, P0
cmovge S2, P0
cmovle S2, P2
cmovg P0, P2
cmp P3, P1
cmovl P2, P1
