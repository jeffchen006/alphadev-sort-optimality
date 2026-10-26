# n=5 model=out iset=I1 prefix14_class=12699
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
cmovg P2, S1
mov S2, P2
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P1, S2
cmovge P2, P1
cmovg P1, S2
cmp P0, P3
cmovg P1, P3
