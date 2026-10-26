# n=5 model=out iset=I1 prefix14_class=2793
mov S0, P3
cmp P1, S0
cmovge S0, P1
cmovl P3, P1
mov S2, P2
cmp P0, S2
cmovl S2, P0
cmovl P0, P2
cmp P0, S0
mov P1, P0
cmovle P1, S0
cmovge P0, S0
cmp P3, S2
cmovl P1, P3
