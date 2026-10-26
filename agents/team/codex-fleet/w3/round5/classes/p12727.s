# n=5 model=out iset=I1 prefix14_class=12727
mov S2, P2
cmp P2, P3
cmovge P2, P3
cmovl S2, P3
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P0, P2
mov S0, P0
cmovle S0, P2
cmovge P0, P2
cmp P1, S2
cmovle P2, S2
