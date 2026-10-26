# n=5 model=out iset=I1 prefix14_class=4611
cmp P0, P2
mov S2, P2
cmovl P2, P0
cmovge S2, P0
mov S0, S2
mov S1, P1
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmp P3, S0
cmovg S0, P3
cmovl S2, P3
mov S0, P2
mov P3, S2
