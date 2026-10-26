# n=5 model=out iset=I1 prefix14_class=10046
mov S0, P3
mov S2, P2
cmp P2, P1
cmovle P2, P1
cmovle P1, S2
cmp P0, S0
cmovl P3, P0
mov S2, P2
cmovle P0, S0
cmp P0, S2
cmovge S2, P0
cmovg P0, P2
cmp P3, P1
cmovg S2, P1
