# n=5 model=out iset=I1 prefix14_class=6500
mov S0, P1
cmp P1, P2
cmovle P1, P2
cmovl P2, S0
cmovl S0, P1
cmp P3, P0
cmovg S2, P0
cmovle S2, P3
cmovge P0, P3
cmp P0, P1
cmovl P1, P0
cmovle P0, S0
cmp P2, S2
cmovge P3, P2
