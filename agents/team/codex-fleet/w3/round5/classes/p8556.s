# n=5 model=out iset=I1 prefix14_class=8556
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
mov S2, P1
cmp P1, P0
cmovle S2, P0
cmovge P1, P0
cmp P2, S2
cmovge S1, P2
cmovg P2, S2
cmovg S2, S1
cmp P1, P3
cmovle S1, P3
