# n=5 model=out iset=I1 prefix14_class=7546
cmp P0, P2
cmovle S2, P0
cmovg S2, P2
cmovg P2, P0
cmp P1, P3
cmovge P0, P3
cmovg P3, P1
cmovge P1, P0
cmp S2, P1
cmovg S1, S2
cmovle S1, P1
cmovl P1, S2
cmp P3, P2
cmovle S2, P3
