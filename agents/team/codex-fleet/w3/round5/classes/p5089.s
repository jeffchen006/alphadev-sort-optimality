# n=5 model=out iset=I1 prefix14_class=5089
cmp P0, P2
cmovg S1, P2
cmovle S1, P0
mov S2, P3
cmovl P0, P2
cmp P1, S2
cmovg P3, P1
cmovge P1, S2
cmp P1, S1
mov S0, S1
cmovg S0, P1
cmovl S1, P1
cmp P3, P0
cmovle P1, P0
