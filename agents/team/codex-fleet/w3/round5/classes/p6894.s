# n=5 model=out iset=I1 prefix14_class=6894
cmp P0, P2
mov S2, P1
mov S0, P2
cmovle P2, P0
cmovle P0, S0
cmp P1, P3
cmovl P1, P3
cmovg S2, P3
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovge S1, P1
cmp P2, S2
cmovge S1, S2
