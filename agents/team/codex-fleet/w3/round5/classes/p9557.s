# n=5 model=out iset=I1 prefix14_class=9557
cmp P1, P0
mov S2, P2
cmovle S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmp P0, S2
cmovg P2, S2
cmovle P2, P0
cmovg S2, P0
cmp P1, P3
cmovl P0, P3
