# n=5 model=out iset=I1 prefix14_class=10830
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovg S2, P0
mov S1, P3
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmp P2, S1
cmovg P3, P2
cmovge P2, S1
cmovg S1, P3
cmp P1, S2
cmovl P3, S2
