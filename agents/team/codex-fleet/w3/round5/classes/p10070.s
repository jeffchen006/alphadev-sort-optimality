# n=5 model=out iset=I1 prefix14_class=10070
mov S2, P0
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
cmovge P3, S0
cmp S2, P1
mov S1, P3
cmovg S2, P1
cmovle P0, P1
cmp S1, P0
cmovl P3, P0
cmovge S1, P0
mov P3, P2
cmp S2, P3
