# n=5 model=out iset=I1 prefix14_class=8850
mov S1, P3
cmp P3, P2
cmovg P3, P2
cmovle S1, P2
cmp P1, P0
cmovle P2, P0
cmovl P0, P1
cmovge P2, P1
cmovle P1, P2
cmp P1, S1
cmovge P2, S1
cmovge S1, P1
cmp P0, P3
mov S1, P2
