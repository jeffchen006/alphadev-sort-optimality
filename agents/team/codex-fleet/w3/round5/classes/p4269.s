# n=5 model=out iset=I1 prefix14_class=4269
cmp P2, P0
mov S0, P1
mov S2, P2
cmovle P2, P0
cmovge S2, P0
cmp S0, P3
cmovg S0, P3
mov P0, S0
cmovge P3, P1
cmp S2, S0
cmovl P0, S2
cmovle S2, S0
cmp P3, P2
mov P0, S2
