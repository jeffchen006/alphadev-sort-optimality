# n=5 model=out iset=I1 prefix14_class=5683
mov S1, P1
cmp S1, P2
cmovg P1, P2
mov S2, P0
cmovg P2, S1
cmp P0, P3
cmovg S2, P3
mov S0, S2
cmovg P3, P0
cmp P1, S2
cmovle S0, P1
cmovl P1, S2
cmp P2, P3
cmovge S2, P3
