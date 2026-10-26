# n=5 model=out iset=I1 prefix14_class=6592
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovge S2, P3
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovl P2, P0
cmp S2, S0
cmovge P3, S2
mov S1, P1
cmovg S2, S0
cmovge S0, P3
cmp S1, P2
