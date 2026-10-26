# n=5 model=out iset=I1 prefix14_class=13805
mov S2, P2
cmp P2, P1
cmovle S2, P1
mov S0, P0
cmovg P2, P1
cmp P0, P3
cmovge S0, P3
cmovl P0, P3
cmp P0, S2
cmovle P1, S2
cmovl S2, P0
cmovle P0, P1
cmp P2, S0
cmovg P0, P2
