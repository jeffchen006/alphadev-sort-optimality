# n=5 model=out iset=I1 prefix14_class=9796
cmp P3, P1
cmovg S2, P3
cmovge P3, P1
cmovle S2, P1
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovl P0, P2
cmp S2, P0
cmovge P2, P0
cmovge P0, S2
mov S0, S1
cmovge S2, P2
cmp P3, S0
