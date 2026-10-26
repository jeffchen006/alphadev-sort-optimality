# n=5 model=out iset=I1 prefix14_class=8382
mov S0, P1
mov S2, P0
cmp S2, P2
cmovle P0, P2
cmovle P2, S2
cmp S0, P3
cmovg S0, P3
cmovge P3, P1
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
mov P1, S0
cmp S0, P2
