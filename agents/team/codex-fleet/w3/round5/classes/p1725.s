# n=5 model=out iset=I1 prefix14_class=1725
cmp P1, P0
cmovl S2, P0
cmovge S2, P1
cmovle P0, P1
cmp P2, P3
mov S0, P0
cmovle P1, P3
cmovle P3, P2
cmovl P2, P1
cmp P3, S0
cmovle S0, P3
cmovg P0, P3
cmp S2, P2
cmovg S0, P2
