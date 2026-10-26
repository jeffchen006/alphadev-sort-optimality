# n=5 model=out iset=I1 prefix14_class=11085
cmp P2, P0
cmovl S2, P0
cmovle P0, P2
cmovge S2, P2
cmp P3, P1
cmovg S0, P3
cmovle S0, P1
cmovl P1, P3
cmp S0, S2
cmovle P2, S2
mov P3, P0
cmovl S2, S0
cmovl S0, P2
cmp P3, P1
