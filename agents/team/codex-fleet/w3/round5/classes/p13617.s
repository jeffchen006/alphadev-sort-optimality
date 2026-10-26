# n=5 model=out iset=I1 prefix14_class=13617
cmp P2, P0
mov S1, P1
cmovg S2, P2
cmovle S2, P0
cmovl P0, P2
cmp P3, S1
cmovg P1, P3
cmovle S1, P3
cmp S1, P0
cmovge P3, P0
cmovge P0, S1
cmovg S1, P3
cmp P1, S2
cmovge P2, S2
