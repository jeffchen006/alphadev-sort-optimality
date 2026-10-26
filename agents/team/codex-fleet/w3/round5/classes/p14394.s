# n=5 model=out iset=I1 prefix14_class=14394
mov S1, P1
cmp P0, P3
mov S2, P3
cmovl P3, P0
cmovge S2, P0
cmp S1, P2
cmovle S1, P2
cmovg P1, P2
cmp P1, P3
cmovge P2, P1
cmovge P1, P3
cmovg P3, P2
mov S0, S1
cmp S2, S1
