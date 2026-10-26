# n=5 model=out iset=I1 prefix14_class=11711
mov S0, P0
cmp P1, P0
cmovg P0, P1
cmovl S0, P1
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P0, P3
cmovge S2, P3
cmovl S2, P0
cmovg P3, P0
cmp P2, S0
cmovle P1, S0
