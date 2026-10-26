# n=5 model=out iset=I1 prefix14_class=2060
cmp P2, P0
cmovle S0, P0
cmovge S0, P2
cmovl P0, P2
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
mov S2, P1
cmp P1, S0
cmovle P1, S0
cmovg S2, S0
mov S0, P3
cmp S0, P0
