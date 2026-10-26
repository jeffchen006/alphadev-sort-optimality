# n=5 model=out iset=I1 prefix14_class=6893
cmp P0, P2
mov S2, P1
mov S0, P2
cmovle P2, P0
cmovle P0, S0
cmp P1, P3
cmovl P1, P3
cmovg S2, P3
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovge S0, P1
cmp P2, S2
cmovge S0, S2
