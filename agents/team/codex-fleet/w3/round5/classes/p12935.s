# n=5 model=out iset=I1 prefix14_class=12935
mov S0, P2
cmp S0, P0
cmovge S0, P0
cmovle P2, P0
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
mov S2, S0
cmp S0, P1
cmovg S2, P1
cmovl S0, P1
cmp P3, P2
mov P0, S0
