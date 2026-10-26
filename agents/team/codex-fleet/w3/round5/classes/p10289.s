# n=5 model=out iset=I1 prefix14_class=10289
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovg S2, P1
cmp P2, P0
mov S1, P3
cmovg P1, P0
cmovge P0, P2
cmovg P2, P1
cmp P0, P3
cmovle P3, P0
cmovge S1, P0
mov S1, S2
cmp P2, S2
