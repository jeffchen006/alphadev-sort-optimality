# n=5 model=out iset=I1 prefix14_class=11208
mov S2, P3
cmp P0, P3
cmovl P3, P0
cmovle P0, S2
cmp P1, P2
mov S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P0, P1
cmovge S0, P1
cmovge P1, P0
mov P1, P2
cmovg P0, S0
cmp P3, P1
