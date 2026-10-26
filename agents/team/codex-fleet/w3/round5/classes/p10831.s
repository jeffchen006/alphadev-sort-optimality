# n=5 model=out iset=I1 prefix14_class=10831
cmp P2, P0
cmovle S2, P2
mov S1, P3
cmovl P2, P0
cmovge S2, P0
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmp P2, S1
cmovge P3, P2
cmovg P2, S1
cmovg S1, P3
mov S1, P2
cmp P1, S2
