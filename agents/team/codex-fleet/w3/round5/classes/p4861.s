# n=5 model=out iset=I1 prefix14_class=4861
mov S1, P0
cmp P0, P3
cmovg P0, P3
mov S2, P2
cmovge P3, S1
cmp P1, P2
cmovl P2, P1
cmovl P1, S2
cmp P2, P0
cmovg S2, P2
cmovle S2, P0
cmovle P0, P2
cmp P3, P1
cmovl P2, P3
