# n=5 model=out iset=I1 prefix14_class=5234
mov S0, P1
cmp P0, P3
mov S1, P3
cmovg S1, P0
cmovge P0, P3
cmp P2, S0
cmovle S0, P2
cmovl P2, P1
cmp S0, P0
cmovge P3, S0
cmovge S0, P0
cmovge P0, P3
mov S2, S1
cmp P2, S2
