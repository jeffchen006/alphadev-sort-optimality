# n=5 model=out iset=I1 prefix14_class=12008
cmp P3, P0
mov S2, P0
cmovle S2, P3
cmovge P0, P3
cmovge P3, S2
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P1, P3
cmovle P3, P1
cmovle P1, S2
cmp P0, P2
cmovg S1, P2
