# n=5 model=out iset=I1 prefix14_class=6335
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmp P0, P3
mov S0, P0
mov S2, P2
cmovle P0, P3
cmovl P3, S0
cmp P2, P0
cmovg S2, P0
cmovl P2, P0
cmp P3, S1
cmovg P0, S1
