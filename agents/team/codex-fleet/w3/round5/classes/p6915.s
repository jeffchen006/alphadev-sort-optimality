# n=5 model=out iset=I1 prefix14_class=6915
mov S0, P3
cmp P0, S0
cmovl P3, P0
mov S2, P2
cmovl P0, S0
cmp S2, P1
cmovle P2, P1
cmovg S2, P1
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
mov P1, P0
cmovl P2, S0
cmp P3, S2
