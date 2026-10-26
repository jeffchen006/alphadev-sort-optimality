# n=5 model=out iset=I1 prefix14_class=4231
mov S1, P0
cmp P1, P0
cmovg P0, P1
mov S0, P2
cmovg P1, S1
cmp P3, S0
cmovg S0, P3
cmovg P3, P2
cmp P1, P3
cmovl S1, P3
cmovge S1, P1
cmovle P3, P1
cmp P0, S0
cmovge P2, P0
