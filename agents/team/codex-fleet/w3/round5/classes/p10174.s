# n=5 model=out iset=I1 prefix14_class=10174
cmp P1, P0
cmovl S1, P1
mov S0, P2
cmovle P1, P0
cmovl P0, S1
cmp P2, P3
cmovge P2, P3
cmovg P3, S0
cmp P3, P1
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P2, P0
mov S0, P2
