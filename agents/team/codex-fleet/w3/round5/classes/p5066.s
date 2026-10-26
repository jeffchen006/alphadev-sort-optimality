# n=5 model=out iset=I1 prefix14_class=5066
mov S0, P3
cmp S0, P1
cmovl S0, P1
cmovge P3, P1
mov S2, P2
cmovle P1, P3
cmp P0, S2
cmovg P2, P0
cmovl S2, P0
cmp P3, S2
cmovg P1, S2
cmovl P3, S2
mov P1, S0
mov S2, P3
