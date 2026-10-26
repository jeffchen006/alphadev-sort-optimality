# n=5 model=out iset=I1 prefix14_class=379
mov S2, P2
cmp P2, P0
cmovle P2, P0
cmovg S2, P0
mov S1, P1
cmp S1, P3
cmovge P1, P3
cmovl S1, P3
mov S0, P1
cmp S2, P1
cmovle S0, S2
mov P3, S1
cmovle S2, P1
mov S0, S2
