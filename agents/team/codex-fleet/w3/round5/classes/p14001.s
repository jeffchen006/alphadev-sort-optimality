# n=5 model=out iset=I1 prefix14_class=14001
mov S2, P2
mov S0, P3
cmp P1, S0
cmovl S0, P1
cmovl P1, P3
cmp P0, S2
cmovg P2, P0
cmovle S2, P0
cmp P1, P2
cmovl P0, P1
cmovl P1, P2
cmovl P2, P0
mov P3, P2
mov S1, S0
