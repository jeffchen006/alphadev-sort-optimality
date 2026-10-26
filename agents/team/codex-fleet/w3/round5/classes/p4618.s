# n=5 model=out iset=I1 prefix14_class=4618
cmp P1, P0
mov S2, P1
cmovl S2, P0
cmovle P0, P1
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P3, S2
cmovge P1, P3
cmovle P1, S2
cmovge P3, S2
mov P1, P0
cmp P2, P0
