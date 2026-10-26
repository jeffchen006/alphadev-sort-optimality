# n=5 model=out iset=I1 prefix14_class=6363
cmp P0, P1
cmovge S1, P0
mov S0, P2
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
cmovl P2, P3
cmovge S0, P3
cmp S0, P1
cmovg S2, P1
cmovle S2, S0
cmovge P1, S0
cmp P0, P2
mov P3, P2
