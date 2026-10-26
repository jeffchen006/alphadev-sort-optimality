# n=5 model=out iset=I1 prefix14_class=9786
mov S0, P2
cmp S0, P0
cmovge S0, P0
mov S2, P1
cmovge P0, P2
cmp P1, P3
cmovg P1, P3
cmovle S2, P3
cmp P0, S2
cmovle S1, P0
cmovl P0, S2
cmovg S1, S2
cmp S0, P1
cmovge P2, P1
