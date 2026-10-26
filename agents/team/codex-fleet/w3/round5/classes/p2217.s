# n=5 model=out iset=I1 prefix14_class=2217
mov S0, P1
cmp P2, S0
mov S1, P3
cmovg P1, P2
cmovge P2, S0
cmp P0, P3
cmovg S1, P0
mov S0, S1
cmovge P0, P3
cmp S1, P1
cmovle S1, P1
cmovl P1, S0
cmp P2, P0
cmovge S1, P0
