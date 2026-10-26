# n=5 model=out iset=I1 prefix14_class=13407
mov S2, P0
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
cmovge P3, S0
cmp P1, S2
cmovg S2, P1
cmovl P0, P1
cmovg P1, P0
cmp P2, P1
cmovle P1, P2
cmovl P2, P0
cmp P3, S2
cmovle P1, P3
