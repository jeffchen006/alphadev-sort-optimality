# n=5 model=out iset=I1 prefix14_class=6850
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovle P2, S0
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovge P0, P2
cmp P3, P1
cmovle P0, P1
