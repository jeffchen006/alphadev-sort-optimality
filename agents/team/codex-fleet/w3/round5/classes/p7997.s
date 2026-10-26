# n=5 model=out iset=I1 prefix14_class=7997
cmp P2, P1
cmovl S1, P2
mov S2, P0
cmovge S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P0, P3
cmovl P0, P3
cmovg S2, P3
cmp S2, S1
cmovg S1, S2
cmovle P2, S2
cmp P0, P1
cmovle S2, S1
