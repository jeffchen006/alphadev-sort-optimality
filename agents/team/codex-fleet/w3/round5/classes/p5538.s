# n=5 model=out iset=I1 prefix14_class=5538
cmp P0, P3
mov S0, P2
cmovg S1, P0
cmovle S1, P3
cmovg P0, P3
cmp S0, P1
cmovl P2, P1
cmovl P1, S0
cmp P0, P1
mov S2, P2
cmovge P3, P1
cmovge P1, P0
cmovge P0, P3
cmp P2, S1
