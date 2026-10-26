# n=5 model=out iset=I1 prefix14_class=10673
cmp P3, P0
cmovl S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovle S2, P1
cmp P3, S2
cmovle S0, S2
cmovle S2, P3
cmovl P3, S0
cmp P2, P0
cmovle S0, P2
