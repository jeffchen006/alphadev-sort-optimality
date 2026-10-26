# n=5 model=out iset=I1 prefix14_class=3143
mov S0, P3
cmp P2, P3
cmovle S0, P2
mov S2, P1
cmovge P3, P2
cmp P0, P1
cmovg S2, P0
cmovle P1, P0
cmp S0, P1
mov P2, S0
cmovg S0, P1
cmovl P2, P1
cmp S2, P3
cmovge S0, P3
