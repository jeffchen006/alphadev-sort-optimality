# n=5 model=out iset=I1 prefix14_class=4889
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp P2, P1
cmovge S1, P1
cmovle S1, P2
mov S0, S1
cmovle P2, P1
cmp S1, P3
cmovge S1, P3
cmovl S0, P3
cmp P2, P0
cmovg P3, P2
