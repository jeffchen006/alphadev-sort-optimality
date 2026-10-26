# n=5 model=out iset=I1 prefix14_class=2545
cmp P1, P0
mov S2, P3
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P3, P2
cmovle P3, P2
cmovle P2, S2
cmp P1, P3
mov S1, P0
cmovge S2, P3
cmovl S2, P1
cmovle P1, P3
cmp P2, S1
