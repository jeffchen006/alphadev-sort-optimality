# n=5 model=out iset=I1 prefix14_class=10583
mov S2, P2
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P1, S2
cmovge P2, P1
cmovl S2, P1
cmp P2, P3
mov S1, S2
cmovle S0, P2
cmovle P2, P3
cmovle P3, S0
cmp P0, S2
