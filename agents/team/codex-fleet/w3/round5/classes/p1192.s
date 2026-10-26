# n=5 model=out iset=I1 prefix14_class=1192
cmp P1, P0
cmovle S1, P1
mov S2, P3
cmovl P1, P0
cmovle P0, S1
mov S1, P1
cmp P3, P2
cmovle S2, P2
cmovge P3, P2
cmp P1, S2
cmovg S1, S2
cmovg S2, P1
cmp P3, P0
cmovle P2, P3
