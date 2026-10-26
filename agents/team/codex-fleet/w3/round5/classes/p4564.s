# n=5 model=out iset=I1 prefix14_class=4564
mov S0, P1
mov S2, P0
cmp P3, P1
cmovge P1, P3
cmovle S0, P3
cmp P2, S2
cmovge P0, P2
cmovge P2, S2
mov S2, P0
cmp P1, P0
cmovg S2, P1
cmovl P0, P1
cmp P2, S0
cmovge S1, P2
