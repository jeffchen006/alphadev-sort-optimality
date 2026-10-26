# n=5 model=out iset=I1 prefix14_class=5586
mov S0, P1
cmp P2, S0
cmovge S0, P2
cmovg P2, P1
mov P1, P3
mov S2, P2
cmp P1, P0
cmovg P1, P0
cmovle P3, P0
cmp P1, S2
cmovge S2, P1
cmovl P2, P1
cmp P3, S0
cmovg S1, P3
