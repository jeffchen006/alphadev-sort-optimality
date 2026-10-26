# n=5 model=out iset=I1 prefix14_class=254
cmp P1, P0
cmovle S0, P1
cmovg S0, P0
cmovge P0, P1
mov S2, P3
cmp P2, S2
cmovge S2, P2
cmovle P3, P2
mov P1, S0
cmp P3, P1
cmovl P1, P3
mov P1, S2
cmovl P3, S0
cmp S2, P0
