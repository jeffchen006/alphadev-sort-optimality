# n=5 model=out iset=I1 prefix14_class=4743
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovg S0, P2
cmp P3, P1
cmovge P2, P1
mov S2, S0
cmovge P1, P3
cmovge P3, P2
cmp P3, S0
cmovge S0, P3
cmovge P3, S2
cmp P1, P0
cmovge S2, P1
