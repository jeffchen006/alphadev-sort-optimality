# n=5 model=out iset=I1 prefix14_class=8851
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovg P3, P2
mov P2, P0
cmp P1, P2
cmovge P0, P1
cmovle P2, P1
cmp P0, S1
cmovge P1, P0
cmovg P0, S1
cmovge S1, P1
cmp P3, P2
cmovl P1, P3
