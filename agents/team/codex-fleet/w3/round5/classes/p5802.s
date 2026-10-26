# n=5 model=out iset=I1 prefix14_class=5802
cmp P3, P2
mov S2, P2
cmovg P2, P3
cmovl S2, P3
cmp P1, P0
cmovg S1, P1
mov P3, S2
cmovg P1, P0
cmovg P0, S1
cmp P1, P3
cmovl S2, P1
cmovge P3, P1
cmp P0, P2
cmovle S2, P2
