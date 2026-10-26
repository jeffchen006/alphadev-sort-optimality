# n=5 model=out iset=I1 prefix14_class=8892
cmp P3, P2
cmovge S1, P3
cmovle S1, P2
cmovge P3, P2
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovge P1, S2
cmp P1, S1
cmovle S2, S1
cmovg S2, P1
cmovl S1, P1
cmp P0, P3
cmovge P1, S1
