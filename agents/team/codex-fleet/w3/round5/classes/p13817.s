# n=5 model=out iset=I1 prefix14_class=13817
mov S0, P2
cmp P2, P0
cmovg P2, P0
mov S2, P1
cmovle S0, P0
cmp P3, P1
cmovl P1, P3
cmovg S2, P3
cmp S2, S0
mov S1, P2
cmovg P3, S0
cmovge S0, S2
cmovg S2, P3
cmp P1, S1
