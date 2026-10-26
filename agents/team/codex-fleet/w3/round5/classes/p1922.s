# n=5 model=out iset=I1 prefix14_class=1922
mov S2, P3
cmp P0, S2
cmovle P3, P0
cmovl P0, S2
cmp P2, P1
mov S1, P1
cmovl P1, P2
cmovge S1, P2
cmp P0, S1
mov S0, P0
cmovg S0, S1
mov S2, P3
cmovle P0, S1
mov P0, S0
