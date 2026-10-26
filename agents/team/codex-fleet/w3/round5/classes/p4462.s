# n=5 model=out iset=I1 prefix14_class=4462
cmp P0, P3
cmovg S2, P3
cmovge P3, P0
cmovg P0, S2
mov S0, P1
cmp P2, P1
mov S2, P3
cmovle P1, P2
cmovge S0, P2
cmp P3, S0
cmovl P3, S0
cmovl S0, S2
cmp P0, P1
cmovge S1, P0
