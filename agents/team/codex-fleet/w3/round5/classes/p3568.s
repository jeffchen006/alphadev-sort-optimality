# n=5 model=out iset=I1 prefix14_class=3568
cmp P2, P3
mov S0, P0
cmovl S1, P2
cmovle P2, P3
cmovl P3, S1
cmp P1, P0
cmovg P0, P1
cmovl S0, P1
cmp P3, S0
cmovge S2, P3
cmovge P3, S0
cmovg S0, S2
mov S2, P0
cmp P2, P0
