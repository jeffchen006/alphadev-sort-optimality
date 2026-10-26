# n=5 model=out iset=I1 prefix14_class=9391
cmp P3, P0
cmovle S1, P0
cmovge S1, P3
cmovge P3, P0
cmp P1, P2
mov S2, P2
cmovle S2, P1
cmovl P1, P2
cmp S2, P3
cmovg P0, S2
cmovg S2, P3
cmovg P3, P0
mov S2, S1
cmp S1, P1
