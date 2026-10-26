# n=5 model=out iset=I1 prefix14_class=12616
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P0, S0
cmovl S2, S0
cmovle S0, P0
cmovl P0, S2
mov S0, P2
cmp P1, S0
