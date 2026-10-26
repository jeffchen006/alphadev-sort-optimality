# n=5 model=out iset=I1 prefix14_class=6117
cmp P1, P2
mov S2, P2
cmovge S2, P1
cmovl P2, P1
mov P1, P0
cmp P3, P0
cmovg P1, P3
cmovge P3, P0
mov S0, P1
cmp S0, S2
cmovg S0, S2
cmovge S2, P1
cmp P3, P2
cmovle S2, P3
