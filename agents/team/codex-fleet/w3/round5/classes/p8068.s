# n=5 model=out iset=I1 prefix14_class=8068
mov S2, P3
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovg P1, P2
cmovge P2, S0
cmp S2, P0
cmovg P3, P0
cmovle S2, P0
cmp P2, P3
cmovl P2, P3
cmovg S0, P3
cmp S2, P1
cmovle S1, P1
