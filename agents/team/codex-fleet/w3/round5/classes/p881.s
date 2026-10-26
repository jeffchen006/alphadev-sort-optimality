# n=5 model=out iset=I1 prefix14_class=881
cmp P3, P2
cmovle S0, P3
cmovge S0, P2
mov S1, P0
cmovl P3, P2
cmp S1, P1
mov S2, P3
cmovg P0, P1
cmovg P1, S1
cmp P1, P3
cmovle S2, P1
cmovge P3, P1
mov S1, S0
cmp S0, P0
