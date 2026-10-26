# n=5 model=out iset=I1 prefix14_class=10703
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmovle P0, S1
mov S2, P3
cmp P1, S2
cmovg S2, P1
mov S0, S2
cmovle P3, P1
cmp S0, P2
cmovl S2, P2
cmovle P2, S0
cmp P3, P0
cmovge S1, P0
