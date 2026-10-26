# n=5 model=out iset=I1 prefix14_class=4020
cmp P3, P1
mov S0, P0
mov S1, P3
cmovle P3, P1
cmovg S1, P1
cmp P2, S0
cmovge P0, P2
cmovl S0, P2
cmp S1, S0
cmovle P1, S1
cmovge P1, S0
cmovle S1, S0
cmp P0, P3
cmovle S2, P3
