# n=5 model=out iset=I1 prefix14_class=1842
cmp P1, P2
mov S2, P1
mov S1, P0
cmovl S2, P2
cmovle P2, P1
cmp P3, S1
cmovge S1, P3
cmovge P3, P0
mov P1, S2
cmp P1, S1
cmovg S2, S1
cmovl P1, S1
mov P1, P2
cmovle S1, S2
