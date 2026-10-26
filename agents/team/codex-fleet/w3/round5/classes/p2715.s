# n=5 model=out iset=I1 prefix14_class=2715
cmp P3, P2
cmovge S0, P3
cmovl S0, P2
mov S1, P1
cmovle P2, P3
cmp P1, P0
cmovle P1, P0
mov S2, P1
cmovle P0, S1
cmp S0, S2
cmovl P1, S0
cmovle S0, S2
mov S0, P2
cmp P0, S0
