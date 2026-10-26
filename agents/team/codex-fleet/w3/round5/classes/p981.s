# n=5 model=out iset=I1 prefix14_class=981
cmp P0, P1
cmovge S0, P0
mov S2, P3
cmovle S0, P1
cmovl P1, P0
cmp P3, P2
cmovge P3, P2
cmovge P2, S2
mov S1, P1
cmp S0, P2
cmovge S2, P2
cmovg P2, S0
cmovg S0, S2
cmp P3, P1
