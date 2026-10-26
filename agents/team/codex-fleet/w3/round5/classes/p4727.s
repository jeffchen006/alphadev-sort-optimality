# n=5 model=out iset=I1 prefix14_class=4727
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovge S1, P1
mov S2, P0
cmp P2, S2
cmovg P0, P2
cmovg P2, S2
mov P1, P2
cmp S1, P1
cmovg P1, S1
cmovg S1, P2
cmp P0, P3
cmovge P2, P3
