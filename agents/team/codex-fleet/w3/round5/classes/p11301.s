# n=5 model=out iset=I1 prefix14_class=11301
mov S2, P2
cmp P0, P3
cmovge S1, P0
cmovle S1, P3
cmovl P3, P0
cmp S2, P1
cmovle S2, P1
cmovl P1, P2
cmp S1, S2
cmovg P2, S1
cmovge S1, S2
cmovg S2, P2
mov S2, P3
cmp P3, P1
