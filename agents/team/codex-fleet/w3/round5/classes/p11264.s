# n=5 model=out iset=I1 prefix14_class=11264
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P0, P2
cmovge P3, P2
cmovge P2, P0
cmovg P0, P3
mov S1, P0
cmp S0, P2
cmovle S2, P2
cmovl P2, S0
cmovge S2, S0
cmovge S0, P2
