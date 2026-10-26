# n=5 model=out iset=I1 prefix14_class=821
mov S1, P3
cmp P3, P2
cmovg P3, P2
cmovle S1, P2
mov P2, P1
cmp P0, P2
mov S2, S1
cmovge P2, P0
cmovl P1, P0
cmp P2, S1
cmovge S1, P2
cmovle S2, P2
mov P0, S2
cmp P1, P3
