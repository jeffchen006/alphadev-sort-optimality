# n=5 model=out iset=I1 prefix14_class=4248
cmp P3, P1
cmovl S0, P3
cmovge S0, P1
cmovg P1, P3
cmovg P3, S0
mov S1, P2
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
cmp P0, S0
cmovg S0, P0
cmovle P3, P0
cmp P1, S1
cmovg P3, S1
