# n=5 model=out iset=I1 prefix14_class=2924
mov S0, P3
cmp P0, S0
cmovle P3, P0
cmovg S0, P0
mov S1, P2
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
mov S2, S1
cmp S0, S1
cmovle S1, S0
mov P2, P3
cmovl S0, S2
mov S0, S1
