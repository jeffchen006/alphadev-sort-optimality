# n=5 model=out iset=I1 prefix14_class=11546
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
mov S2, P1
cmovle P0, S1
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmp P3, P2
cmovle S0, P2
cmovg S0, P3
cmovge P3, P2
cmp P0, S2
cmovg P1, P0
