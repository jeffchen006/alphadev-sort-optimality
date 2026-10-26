# n=5 model=out iset=I1 prefix14_class=10978
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmovge P2, S2
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
mov S2, P0
cmp P0, P2
cmovl P0, P2
cmovl P2, S2
cmp P3, P1
cmovle S2, P1
