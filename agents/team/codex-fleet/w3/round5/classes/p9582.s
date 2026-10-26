# n=5 model=out iset=I1 prefix14_class=9582
cmp P2, P0
cmovl S2, P2
mov S0, P1
cmovle P2, P0
cmovl P0, S2
cmp P3, P1
cmovge P1, P3
cmovge P3, S0
cmp P1, P2
mov S0, P2
cmovl S0, P1
cmovge P2, P1
cmp P3, P0
cmovle S2, P0
