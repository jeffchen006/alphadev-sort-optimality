# n=5 model=out iset=I1 prefix14_class=875
cmp P1, P2
cmovle S2, P1
cmovl P1, P2
mov S1, P0
cmovg S2, P2
cmp P0, P3
cmovg P0, P3
mov P2, P1
cmovg P3, S1
cmp P3, P1
cmovge P1, P3
cmovl P2, P3
cmp P0, S2
cmovge S1, P0
