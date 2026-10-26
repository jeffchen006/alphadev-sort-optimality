# n=5 model=out iset=I1 prefix14_class=5860
mov S2, P2
cmp S2, P3
cmovl P2, P3
cmovge S2, P3
mov P3, P0
cmp P1, P0
cmovl P0, P1
cmovl P1, P3
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovl P2, P1
cmp P0, S2
cmovle P3, P0
