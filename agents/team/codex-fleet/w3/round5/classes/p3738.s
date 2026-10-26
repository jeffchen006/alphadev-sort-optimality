# n=5 model=out iset=I1 prefix14_class=3738
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovge S0, P2
mov S1, P0
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
cmp P1, P3
cmovle S2, P3
cmovg S2, P1
cmovl P3, P1
cmp S0, P0
cmovg P2, S0
