# n=5 model=out iset=I1 prefix14_class=3072
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp P0, P1
cmovle S2, P0
cmovg S2, P1
cmovl P0, P1
mov S0, P0
cmp P3, S2
cmovge P1, P3
cmovge P3, S2
cmovge S2, P1
cmp P2, S0
