# n=5 model=out iset=I1 prefix14_class=3909
cmp P1, P2
mov S2, P1
cmovge P1, P2
cmovge P2, S2
cmp P0, P3
cmovl S2, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, P3
cmovle S0, P3
cmovg S0, P1
cmovl P3, P1
mov P3, S0
cmp P0, P2
