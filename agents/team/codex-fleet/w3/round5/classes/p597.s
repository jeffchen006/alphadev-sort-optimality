# n=5 model=out iset=I1 prefix14_class=597
cmp P3, P1
cmovg S2, P1
mov S1, P2
cmovle S2, P3
cmovl P3, P1
mov P1, P3
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmp P0, P3
cmovl P1, P0
cmovg P3, P0
cmp S2, S1
cmovg S0, S2
