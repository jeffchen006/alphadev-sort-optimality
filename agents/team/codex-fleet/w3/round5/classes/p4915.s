# n=5 model=out iset=I1 prefix14_class=4915
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
mov S2, P1
cmovl P0, S0
cmp P3, P2
mov S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P1, S0
cmovge P1, S0
cmovl S2, S0
cmp P3, P0
cmovl P2, P0
