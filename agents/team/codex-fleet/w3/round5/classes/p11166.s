# n=5 model=out iset=I1 prefix14_class=11166
cmp P3, P0
mov S0, P0
cmovl S0, P3
cmovge P0, P3
mov S1, P1
cmp S1, P2
cmovle S1, P2
cmovge P1, P2
mov S2, P0
cmp S1, S2
cmovl P0, S1
cmovle S1, S2
cmp S0, P1
cmovg S2, P1
