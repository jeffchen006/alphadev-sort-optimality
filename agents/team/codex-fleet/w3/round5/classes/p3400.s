# n=5 model=out iset=I1 prefix14_class=3400
mov S0, P3
cmp P2, P3
mov S1, P0
cmovge P3, P2
cmovle S0, P2
cmp P1, S1
cmovg S1, P1
cmovl P0, P1
mov S2, P0
cmp S0, P0
cmovg S2, S0
cmovge S0, P0
cmp P3, S1
cmovge P0, P3
