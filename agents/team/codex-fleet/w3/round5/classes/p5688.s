# n=5 model=out iset=I1 prefix14_class=5688
mov S2, P1
cmp P1, P2
mov S0, P0
cmovg S2, P2
cmovge P2, P1
cmp S0, P3
mov S1, S2
cmovge P0, P3
cmovge P3, S0
cmp P0, S2
cmovle S1, P0
cmovl P0, S2
cmp P3, P2
cmovle S2, P2
