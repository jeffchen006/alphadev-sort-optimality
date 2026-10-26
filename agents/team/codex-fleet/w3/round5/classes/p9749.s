# n=5 model=out iset=I1 prefix14_class=9749
cmp P0, P2
cmovl S1, P0
cmovge S1, P2
cmovg P2, P0
cmp P3, P1
cmovle P0, P1
cmovl P1, P3
cmovle P3, P0
cmp P3, P2
mov S2, S1
cmovg S0, P3
cmovge P3, P2
cmovg P2, S0
cmp S1, P1
