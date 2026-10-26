# n=5 model=out iset=I1 prefix14_class=5019
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
mov S2, P1
cmovle S0, P0
cmp P1, P2
cmovg S2, P2
cmovl P1, P2
cmp S0, S2
cmovge P0, S2
cmovl P0, S0
cmovge S2, S0
cmp P1, P3
cmovge P2, P1
