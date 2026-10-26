# n=5 model=out iset=I1 prefix14_class=129
mov S1, P0
cmp P0, P1
cmovge P0, P1
mov S0, P2
cmovl S1, P1
cmp P3, P2
mov S2, P0
cmovle P2, P3
cmovg S0, P3
cmp P2, S2
cmovle S2, P2
mov P1, S0
cmovle P2, P0
cmp S1, P1
