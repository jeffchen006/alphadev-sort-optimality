# n=5 model=out iset=I1 prefix14_class=1158
mov S2, P2
mov S0, P3
cmp P3, P0
cmovl S0, P0
cmovle P0, P3
cmp S2, P1
cmovge P2, P1
cmovl S2, P1
mov S1, S2
mov P3, P0
cmp S2, S0
cmovle S1, S0
cmovg S2, S0
cmovl S0, S2
