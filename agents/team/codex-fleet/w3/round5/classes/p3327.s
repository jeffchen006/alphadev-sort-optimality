# n=5 model=out iset=I1 prefix14_class=3327
mov S0, P2
cmp P3, P2
cmovge P2, P3
mov S2, P1
cmovle S0, P3
cmp S2, P0
cmovge P1, P0
mov P3, P1
cmovge P0, S2
cmp P3, S0
cmovge P1, S0
cmovl P3, S0
cmp P0, P2
cmovge S0, P3
