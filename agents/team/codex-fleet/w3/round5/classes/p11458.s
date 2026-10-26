# n=5 model=out iset=I1 prefix14_class=11458
mov S0, P3
cmp P3, P0
cmovl P3, P0
mov S2, P2
cmovl P0, S0
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
cmp S2, P0
mov S1, P0
cmovg P0, S2
cmovle S1, S2
cmp P3, P1
cmovge P2, P1
