# n=5 model=out iset=I1 prefix14_class=7266
cmp P2, P0
cmovle S1, P2
mov S0, P3
cmovl P2, P0
cmovle P0, S1
cmp P1, S0
cmovl P3, P1
cmovl P1, S0
cmp P0, P3
cmovge S0, P3
cmovl S0, P0
cmovge P3, P0
mov S0, P1
cmp P2, P1
