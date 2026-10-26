# n=5 model=out iset=I1 prefix14_class=13315
mov S0, P2
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
mov S2, P2
cmovl P0, S0
cmp P0, S2
cmovl S2, P0
cmovge P2, P0
mov S2, P3
cmp P3, P1
