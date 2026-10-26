# n=5 model=out iset=I1 prefix14_class=4235
mov S1, P0
cmp P3, P0
cmovge P0, P3
mov S0, P1
cmovg P3, S1
cmp P2, P1
cmovge S0, P2
cmovg P2, P1
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovg S1, P3
cmp S0, P0
cmovge P1, S0
