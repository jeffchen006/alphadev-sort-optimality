# n=5 model=out iset=I1 prefix14_class=11834
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
mov S2, P0
cmovl P1, S0
mov S1, P2
cmp P2, P3
cmovl P2, P3
cmovl P3, S1
cmp P2, S2
cmovge P0, P2
cmovle S2, P2
cmp P3, P1
mov S1, S2
