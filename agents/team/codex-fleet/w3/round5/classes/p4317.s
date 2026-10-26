# n=5 model=out iset=I1 prefix14_class=4317
cmp P3, P2
mov S2, P1
cmovle S0, P3
cmovle P3, P2
cmovge S0, P2
cmp P0, P1
cmovle P1, P0
mov S1, P1
cmovle P0, S2
cmp S1, S0
cmovle P1, S0
cmovl S0, S1
cmp P0, P3
cmovl S0, P3
